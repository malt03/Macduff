//
//  ImageProvider.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation

public protocol ImageProvider {
    var cacheKey: String { get }
    func run(progress: @escaping (Float) -> Void, success: @escaping (ProvidingImage) -> Void, failure: @escaping (Error) -> Void)
}

public struct ProvidingImage {
    public let image: NativeImage
    public let originalData: Data?
    
    public init(image: NativeImage, originalData: Data?) {
        self.image = image
        self.originalData = originalData
    }
}
