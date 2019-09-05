//
//  ImageProcessor.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/06.
//

import Foundation

public protocol ImageProcessor {
    var cacheKey: String { get }
    func process(image: NativeImage) -> NativeImage?
}

extension Array: ImageProcessor where Element: ImageProcessor {
    public var cacheKey: String { map { $0.cacheKey }.joined(separator: ">") }
    public func process(image: NativeImage) -> NativeImage? {
        reduce(image) { (image, processor) -> NativeImage? in
            guard let image = image else { return nil }
            return processor.process(image: image)
        }
    }
}
