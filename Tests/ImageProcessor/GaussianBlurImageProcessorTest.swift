//
//  GaussianBlurImageProcessorTest.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/07.
//

import XCTest
@testable import Macduff

final class GaussianBlurImageProcessorTest: XCTestCase {
    func test() {
        let processed = GaussianBlurImageProcessor().process(image: getImage(resourceName: "Lena"))!
        let expected = getImage(resourceName: "BlurLena")
        XCTAssertEqual(createRawData(from: processed), createRawData(from: expected))
    }
}
