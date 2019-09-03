//
//  DiskCache.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation

final class DiskCache: Cache {
    private static var defaultCacheDirectory: URL? {
        let userCacheDirectory = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return userCacheDirectory?.appendingPathComponent("com.malt03.RemoteImage.DiskCache")
    }
    
    let fallbackCache: Cache?
    
    private let cacheDirectory: URL
    
    init?(cacheDirectory: URL? = defaultCacheDirectory, fallbackCache: Cache? = nil) {
        guard let cacheDirectory = cacheDirectory else { return nil }
        self.fallbackCache = fallbackCache
        self.cacheDirectory = cacheDirectory
        
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    private func cacheURL(for key: String) -> URL {
        return cacheDirectory.appendingPathComponent(key)
    }
    
    func store(image: CacheImage, for key: String) {
        image.write(to: cacheURL(for: key))
    }
    
    func get(for key: String) -> CacheImage? {
        let cacheURL = self.cacheURL(for: key)
        guard let image = CacheImage(contentsOf: cacheURL) else { return nil }
        if image.isExpired {
            try? FileManager.default.removeItem(at: cacheURL)
            return nil
        }
        return image
    }
}

extension CacheImage {
    private static let expiresAtBufferSize: Int = MemoryLayout<TimeInterval>.size
    
    func write(to url: URL) {
        var expiresAtSince1970 = expiresAt.timeIntervalSince1970
        var data = Data(bytes: &expiresAtSince1970, count: CacheImage.expiresAtBufferSize)
        data.append(originalData)
        try? data.write(to: url)
    }
    
    convenience init?(contentsOf url: URL) {
        guard let data = try? Data(contentsOf: url) else { return nil }
        if data.count <= CacheImage.expiresAtBufferSize { return nil }
        let expiresAtSince1970 = data.prefix(CacheImage.expiresAtBufferSize).withUnsafeBytes { $0.load(as: TimeInterval.self) }
        let expiresAt = Date(timeIntervalSince1970: expiresAtSince1970)
        let originalData = data.suffix(from: CacheImage.expiresAtBufferSize)
        self.init(originalData: originalData, expiresAt: expiresAt)
    }
}
