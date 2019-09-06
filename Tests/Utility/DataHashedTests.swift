//
//  DataHashedTests.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/07.
//

import XCTest
@testable import Macduff

class DataHashedTests: XCTestCase {
    func testExample() {
        XCTAssertEqual("Hello World!".data(using: .utf8)!.hashed, "7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069")
    }
}
