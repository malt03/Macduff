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
        guard let ciImage = image.ciImage ?? CIImage(image: image) else { return nil }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        guard let outputCIImage = filter.outputImage else { return nil }
        
        // We cannot use `NativeImage(ciImage: outputCIImage)`.
        // Because SwiftUI `Image` could not present `UIImage` created with `CIImage`.
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }
        return NativeImage(cgImage: cgImage)
    }
    
    private let filter: CIFilter
    
    public init(filter: CIFilter) {
        self.filter = filter
        cacheKey = "com.malt03.Macduff.CIFilterImageProcessor.\(filter.name).\(String(describing: filter.attributes))"
    }
}
