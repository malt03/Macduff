//
//  CacheImage.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation

public final class CacheImage: HasExpiresAt {
    let originalData: Data
    let expiresAt: Date
    
    init(originalData: Data, expiresAt: Date) {
        self.originalData = originalData
        self.expiresAt = expiresAt
    }
    
    var image: NativeImage? {
        NativeImage(data: originalData)
    }
}

protocol HasExpiresAt {
    var expiresAt: Date { get }
}

extension HasExpiresAt {
    var isExpired: Bool {
        return expiresAt.timeIntervalSince(Date()) < 0
    }
}
