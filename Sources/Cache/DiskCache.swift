//
//  DiskCache.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation
import Combine

public final class DiskCache: Cache {
    public static var defaultCacheDirectory: URL? {
        let userCacheDirectory = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return userCacheDirectory?.appendingPathComponent("com.malt03.Macduff.DiskCache")
    }
    
    public func removeAll() throws {
        if !FileManager.default.fileExists(atPath: cacheDirectory.path) { return }
        try FileManager.default.removeItem(at: cacheDirectory)
        try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    public init?(cacheDirectory: URL? = defaultCacheDirectory, fallbackCache: Cache? = nil) {
        guard let cacheDirectory = cacheDirectory else { return nil }
        do {
            try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }

        self.fallbackCache = fallbackCache
        self.cacheDirectory = cacheDirectory
        
        NotificationCenter.default.didEnterBackground()?.sink { [weak self] _ in self?.clean() }.store(in: &cancellables)
    }
    
    public let fallbackCache: Cache?
    private let cacheDirectory: URL
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    private func clean() {
        var willExpiration = false
        backgroundTask(expirationHandler: {
            willExpiration = true
        }, task: { (completion) in
            DispatchQueue.global(qos: .background).async {
                do {
                    let contents = try FileManager.default.contentsOfDirectory(at: self.cacheDirectory, includingPropertiesForKeys: [], options: [])
                    for content in contents {
                        if willExpiration { break }
                        guard let info = try? CacheImage.Info.load(from: content) else {
                            try? FileManager.default.removeItem(at: content)
                            continue
                        }
                        if !info.isExpired { continue }
                        try? FileManager.default.removeItem(at: content)
                    }
                } catch {}
                completion()
            }
        })
    }
    
    private func cacheURL(for key: String) -> URL {
        return cacheDirectory.appendingPathComponent(key)
    }
    
    public func store(image: CacheImage, for key: String) {
        try? image.write(to: cacheURL(for: key))
    }
    
    public func get(for key: String) -> CacheImage? {
        let cacheURL = self.cacheURL(for: key)
        guard let image = try? CacheImage(contentsOf: cacheURL) else { return nil }
        if image.isExpired {
            try? FileManager.default.removeItem(at: cacheURL)
            return nil
        }
        return image
    }
}

extension CacheImage {
    private static let expiresAtBufferSize: Int = MemoryLayout<TimeInterval>.size
    
    private static func originalDataURL(base: URL) -> URL {
        base.appendingPathComponent("image")
    }
    
    fileprivate func write(to url: URL) throws {
        if !FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        try originalData.write(to: CacheImage.originalDataURL(base: url))
        try info.write(to: url)
    }
    
    fileprivate convenience init(contentsOf url: URL) throws {
        let imageData = try Data(contentsOf: CacheImage.originalDataURL(base: url))
        let info = try Info.load(from: url)
        
        self.init(originalData: imageData, info: info)
    }
}

extension CacheImage.Info {
    private static func url(base: URL) -> URL {
        base.appendingPathComponent("info.json")
    }
    
    fileprivate static func load(from base: URL) throws -> CacheImage.Info {
        return try JSONDecoder().decode(CacheImage.Info.self, from: try Data(contentsOf: CacheImage.Info.url(base: base)))
    }
    
    fileprivate func write(to base: URL) throws {
        try JSONEncoder().encode(self).write(to: CacheImage.Info.url(base: base))
    }
}
