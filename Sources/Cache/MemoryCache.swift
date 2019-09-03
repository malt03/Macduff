//
//  MemoryCache.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation

final class MemoryCache: Cache {
    static var defaultByteLimit: Int {
        let limit = ProcessInfo.processInfo.physicalMemory / 4
        return Int(min(limit, UInt64(Int.max)))
    }
    
    let fallbackCache: Cache?
    
    init(byteLimit: Int = defaultByteLimit, fallbackCache: Cache? = DiskCache()) {
        self.fallbackCache = fallbackCache
        cache.totalCostLimit = byteLimit
    }
    
    private let cache = NSCache<NSString, ExpirableImage>()
    private var allCachedKeys = Set<NSString>()
    private let lock = NSLock()

    private func clean() {
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
    
    func store(image: ExpirableImage, for key: String) {
        lock.lock()
        defer { lock.unlock() }

        cache.setObject(image, forKey: key as NSString, cost: image.value.cacheCost)
        allCachedKeys.insert(key as NSString)
    }
    
    func get(for key: String) -> NativeImage? {
        lock.lock()
        defer { lock.unlock() }

        guard let cached = cache.object(forKey: key as NSString) else { return nil }
        if cached.isExpired {
            cache.removeObject(forKey: key as NSString)
            allCachedKeys.remove(key as NSString)
            return nil
        }
        return cached.value
    }
    
}
