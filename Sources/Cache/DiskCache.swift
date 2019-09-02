//
//  DiskCache.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation

final class DiskCache: Cache {
    let wrapped: Cache? = MemoryCache()
    
    func store(image: ExpirableImage, for key: String) {
        
    }
    
    func get(for key: String) -> NativeImage? {
        return nil
    }
    
}
