//
//  MemoryCache.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation
import Combine

public final class MemoryCache: Cache {
    public static var defaultByteLimit: Int {
        let limit = ProcessInfo.processInfo.physicalMemory / 4
        return Int(min(limit, UInt64(Int.max)))
    }
    
    public let fallbackCache: Cache?
    
    public init(byteLimit: Int = defaultByteLimit, cleanInterval: TimeInterval = 120, fallbackCache: Cache? = DiskCache()) {
        self.fallbackCache = fallbackCache
        cache.totalCostLimit = byteLimit
        
        cleanTimer = Timer.scheduledTimer(withTimeInterval: cleanInterval, repeats: true, block: { [weak self] _ in
            self?.clean()
        })
        
        NotificationCenter.default.publisherForMemoryWarning()?.sink(receiveValue: { [weak self] _ in
            self?.removeAll()
        }).store(in: &cancellables)
    }
    
    deinit {
        cleanTimer?.invalidate()
        cancellables.forEach { $0.cancel() }
    }
    
    private let cache = NSCache<NSString, CacheImage>()
    private var allCachedKeys = Set<NSString>()
    private let lock = NSLock()
    private var cleanTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    public func clean() {
        lock.lock()
        defer { lock.unlock() }

        for key in allCachedKeys {
            guard let cached = cache.object(forKey: key) else {
                allCachedKeys.remove(key)
                continue
            }
            if !cached.isExpired { continue }
            cache.removeObject(forKey: key)
            allCachedKeys.remove(key)
        }
    }
    
    public func store(image: CacheImage, for key: String) {
        lock.lock()
        defer { lock.unlock() }

        cache.setObject(image, forKey: key as NSString, cost: image.originalData.count)
        allCachedKeys.insert(key as NSString)
    }
    
    public func get(for key: String) -> CacheImage? {
        lock.lock()
        defer { lock.unlock() }

        guard let cached = cache.object(forKey: key as NSString) else { return nil }
        if cached.isExpired {
            cache.removeObject(forKey: key as NSString)
            allCachedKeys.remove(key as NSString)
            return nil
        }
        return cached
    }
    
    public func removeAll() {
        lock.lock()
        defer { lock.unlock() }

        cache.removeAllObjects()
        allCachedKeys.removeAll()
    }
}
