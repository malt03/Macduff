//
//  ImageProcessorArrayTest.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/07.
//

import XCTest
@testable import Macduff

final class ImageProcessorArrayTest: XCTestCase {
    
    struct Processor: ImageProcessor {
        let cacheKey: String
        let callHandler: () -> Void
        
        func process(image: NativeImage) -> NativeImage? {
            callHandler()
            return image
        }
    }
    
    func test() {
        var step = 0
        let processor1 = Processor(cacheKey: "p1") {
            XCTAssertEqual(step, 0)
            step += 1
        }
        let processor2 = Processor(cacheKey: "p2") {
            XCTAssertEqual(step, 1)
            step += 1
        }
        let arrayProcessor = [processor1, processor2] as ImageProcessor
        let image = getImage(resourceName: "Lena")
        let processed = arrayProcessor.process(image: image)
        
        XCTAssertEqual(processed, image)
        XCTAssertEqual(step, 2)
        XCTAssertEqual(arrayProcessor.cacheKey, "p1>p2")
    }
}
