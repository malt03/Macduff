//
//  Cache.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation

public protocol Cache: class {
    func store(image: CacheImage, for key: String)
    func get(for key: String) -> CacheImage?
    var fallbackCache: Cache? { get }
}

extension Cache {
    private var queue: DispatchQueue { return DispatchQueue(label: "com.malt03.RemoteImage.ImageCache") }
    
    func getOrStore(
        key: String?,
        ttl: TimeInterval,
        provide: @escaping (@escaping (ProvidingImage) -> Void) -> Void,
        result: @escaping (NativeImage) -> Void
    ) {
        queue.async {
            if let key = key {
                if let cached = self.get(for: key)?.image {
                    result(cached)
                    return
                }
                if let fallbackCached = self.fallbackCache?.get(for: key), let image = fallbackCached.image {
                    self.store(image: fallbackCached, for: key)
                    result(image)
                    return
                }
            }

            provide { (provided) in
                let cacheImage = CacheImage(originalData: provided.originalData, expiresAt: Date().addingTimeInterval(ttl))
                if let key = key {
                    self.store(image: cacheImage, for: key)
                    self.fallbackCache?.store(image: cacheImage, for: key)
                }
                result(provided.image)
            }
        }
    }
}
