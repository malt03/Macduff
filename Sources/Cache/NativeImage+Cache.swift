//
//  NativeImage+Cache.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation


extension NativeImage {
    var cacheCost: Int {
        let pixelCount = Int(size.width * size.height * scale * scale)
        let bitsPerPixel = cgImage?.bitsPerPixel ?? 32
        return pixelCount * bitsPerPixel / 8
    }
    
    func withExpiresAt(_ expiresAt: Date) -> ExpirableImage {
        return ExpirableImage(image: self, expiresAt: expiresAt)
    }
}
