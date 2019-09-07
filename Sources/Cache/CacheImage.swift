//
//  CacheImage.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation

public final class CacheImage {
    let originalData: Data
    let info: Info
    
    struct Info: Codable {
        let expiresAt: Date
        
        var isExpired: Bool {
            return expiresAt.timeIntervalSince(DateGenerator.now()) < 0
        }
    }
    
    var isExpired: Bool {
        return info.isExpired
    }

    init(originalData: Data, info: Info) {
        self.originalData = originalData
        self.info = info
    }
    
    var image: NativeImage? {
        NativeImage(data: originalData)
    }
}
