//
//  AppUITests.swift
//  AppUITests
//
//  Created by Koji Murata on 2019/09/09.
//

import XCTest
@testable import Macduff

class AppUITests: XCTestCase {
    func test() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        XCTAssertEqual(app.staticTexts.firstMatch.label, "0.0")
        XCTAssertFalse(app.images.firstMatch.exists)
        
        app.buttons.firstMatch.tap()
        
        XCTAssertEqual(app.staticTexts.firstMatch.label, "0.0")
        XCTAssertFalse(app.images.firstMatch.exists)

        app.buttons.firstMatch.tap()

        XCTAssertEqual(app.staticTexts.firstMatch.label, "0.5")
        XCTAssertFalse(app.images.firstMatch.exists)

        app.buttons.firstMatch.tap()

        XCTAssertFalse(app.staticTexts.firstMatch.exists)
        XCTAssertTrue(app.images.firstMatch.exists)

        app.buttons.firstMatch.tap()

        XCTAssertEqual(app.staticTexts.firstMatch.label, "0.0")
        XCTAssertFalse(app.images.firstMatch.exists)

        app.buttons.firstMatch.tap()
        
        XCTAssertFalse(app.staticTexts.firstMatch.exists)
        XCTAssertTrue(app.images.firstMatch.exists)

        app.buttons.firstMatch.tap()

        XCTAssertEqual(app.staticTexts.firstMatch.label, "0.0")
        XCTAssertFalse(app.images.firstMatch.exists)

        app.buttons.firstMatch.tap()

        XCTAssertEqual(app.staticTexts.firstMatch.label, "The operation couldn’t be completed. (AppForUITest.ContentView.Errors error 0.)")
        XCTAssertFalse(app.images.firstMatch.exists)
    }
}
