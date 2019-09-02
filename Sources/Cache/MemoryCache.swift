//
//  MemoryCache.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation

final class MemoryCache: Cache {
    private let cache = NSCache<NSString, ExpirableImage>()
    var wrapped: Cache? { return nil }
    
    func store(image: ExpirableImage, for key: String) {
        cache.setObject(image, forKey: key as NSString, cost: image.value.cacheCost)
    }
    
    func get(for key: String) -> NativeImage? {
        return cache.object(forKey: key as NSString)?.value
    }
    
}
