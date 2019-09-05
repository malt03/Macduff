//
//  CIFilterImageProcessor.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/06.
//

import Foundation
import CoreImage

open class CIFilterImageProcessor: ImageProcessor {
    public let cacheKey: String
    
    public func process(image: NativeImage) -> NativeImage? {
        guard let ciImage = image.ciImage else { return nil }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputImage = filter.outputImage else { return nil }
        return NativeImage(ciImage: outputImage)
    }
    
    private let filter: CIFilter
    
    public init(filter: CIFilter) {
        self.filter = filter
        cacheKey = "com.malt03.Macduff.CIFilterImageProcessor.\(filter.name).\(String(describing: filter.attributes))"
    }
}
