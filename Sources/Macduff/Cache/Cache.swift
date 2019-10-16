//
//  Cache.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation

public protocol Cache: class {
    func store(image: CacheImage, for key: String)
    func get(for key: String) -> CacheImage?
    var fallbackCache: Cache? { get }
}

fileprivate let cacheQueue = DispatchQueue(label: "com.malt03.Macduff.ImageCache")

extension Cache {
    var queue: DispatchQueue { return cacheQueue }
    
    func getOrStore(
        key: CacheKey,
        ttl: TimeInterval,
        provide: @escaping (@escaping (ProvidingImage) -> Void) -> Void,
        result: @escaping (NativeImage) -> Void
    ) {
        let cacheKey = key.generate()
        queue.async {
            if let key = cacheKey {
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
                result(provided.image)
                
                guard let data = provided.originalData ?? provided.image.pngData() else { return }
                let cacheImage = CacheImage(originalData: data, info: .init(expiresAt: DateGenerator.now().addingTimeInterval(ttl)))
                if let key = cacheKey {
                    self.store(image: cacheImage, for: key)
                    self.fallbackCache?.store(image: cacheImage, for: key)
                }
            }
        }
    }
}
