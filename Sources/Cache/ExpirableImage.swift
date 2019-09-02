//
//  ExpirableImage.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation

public final class ExpirableImage {
    let value: NativeImage
    let expiresAt: Date
    
    init(image: NativeImage, expiresAt: Date) {
        self.value = image
        self.expiresAt = expiresAt
    }
    
    var isExpired: Bool {
        return expiresAt.timeIntervalSince(Date()) < 0
    }
}
