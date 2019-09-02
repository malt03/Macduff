//
//  DiskCache.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation

final class DiskCache: Cache {
    var wrapped: Cache? { return nil }
    
    func store(image: NativeImage, for key: String, expiresAt: Date) {
        
    }
    
    func get(for key: String) -> NativeImage? {
        return nil
    }
    
}
