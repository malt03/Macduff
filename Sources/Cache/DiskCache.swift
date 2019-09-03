//
//  DiskCache.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation

public final class DiskCache: Cache {
    public static var defaultCacheDirectory: URL? {
        let userCacheDirectory = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return userCacheDirectory?.appendingPathComponent("com.malt03.RemoteImage.DiskCache")
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
    }
    
    public let fallbackCache: Cache?
    private let cacheDirectory: URL
    
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
    
    private static func infoURL(base: URL) -> URL {
        base.appendingPathComponent("info.json")
    }
    
    fileprivate func write(to url: URL) throws {
        if !FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        try originalData.write(to: CacheImage.originalDataURL(base: url))
        try JSONEncoder().encode(info).write(to: CacheImage.infoURL(base: url))
    }
    
    fileprivate convenience init(contentsOf url: URL) throws {
        let imageData = try Data(contentsOf: CacheImage.originalDataURL(base: url))
        let info = try JSONDecoder().decode(Info.self, from: try Data(contentsOf: CacheImage.infoURL(base: url)))
        self.init(originalData: imageData, info: info)
    }
}
