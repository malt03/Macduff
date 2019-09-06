//
//  GaussianBlurImageProcessor.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/06.
//

import Foundation
import CoreImage

public struct GaussianBlurImageProcessor: CIFilterImageProcessor {
    public let cacheKey: String
    public let filter: CIFilter
    
    public init(radius: Double = 10) {
        cacheKey = "com.malt03.Macduff.GaussianBlurImageProcessor.\(radius)"
        filter = CIFilter(name: "CIGaussianBlur", parameters: [kCIInputRadiusKey: NSNumber(floatLiteral: radius)])!
    }
}
