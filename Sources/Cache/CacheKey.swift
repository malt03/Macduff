//
//  CacheKey.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/06.
//

import Foundation

struct CacheKey {
    let provider: ImageProvider
    let processor: ImageProcessor?
    
    func generate() -> String? {
        let encodable = EncodableCacheKey(provider: provider.cacheKey, processor: processor?.cacheKey)
        return try? JSONEncoder().encode(encodable).hashed
    }
    
    private struct EncodableCacheKey: Encodable {
        let provider: String
        let processor: String?
    }
}
