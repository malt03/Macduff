//
//  CacheImage.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation

public final class CacheImage {
    let originalData: Data
    let info: Info
    
    struct Info: Codable {
        let expiresAt: Date
    }
    
    var isExpired: Bool {
        return info.expiresAt.timeIntervalSince(Date()) < 0
    }

    init(originalData: Data, info: Info) {
        self.originalData = originalData
        self.info = info
    }
    
    var image: NativeImage? {
        NativeImage(data: originalData)
    }
}
