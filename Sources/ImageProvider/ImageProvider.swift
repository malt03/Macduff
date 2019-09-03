//
//  ImageProvider.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation
import Combine

public protocol ImageProvider {
    var cacheKey: String { get }
    func run(progress: @escaping (Float) -> Void, success: @escaping (ProvidingImage) -> Void, failure: @escaping (Error) -> Void)
}

public struct ProvidingImage {
    let image: NativeImage
    let originalData: Data
}
