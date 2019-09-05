//
//  GaussianBlurImageProcessor.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/06.
//

import Foundation
import CoreImage

public final class GaussianBlurImageProcessor: CIFilterImageProcessor {
    public init(radius: Double = 10) {
        super.init(filter: CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": NSNumber(floatLiteral: radius)])!)
    }
}
