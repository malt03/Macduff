//
//  ImageProvider.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation
import CryptoKit

public protocol ImageProvider {
    var cacheKey: String { get }
    func run(progress: @escaping (Float) -> Void, success: @escaping (ProvidingImage) -> Void, failure: @escaping (Error) -> Void)
}

extension ImageProvider {
    var hashedCacheKey: String? {
        guard let cacheKeyData = cacheKey.data(using: .utf8) else { return nil }
        return SHA256.hash(data: cacheKeyData).reduce("", { return $0 + String(format: "%02x", $1) })
    }
}

public struct ProvidingImage {
    let image: NativeImage
    let originalData: Data
}
