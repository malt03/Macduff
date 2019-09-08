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

        XCTAssertEqual(app.staticTexts.count, 3)
        XCTAssertEqual(app.staticTexts.allElementsBoundByIndex.filter { $0.label == "0.0" }.count, 2)
        XCTAssertEqual(app.staticTexts.allElementsBoundByIndex.filter { $0.label == "PlaceHolder" }.count, 1)
        XCTAssertFalse(app.images.firstMatch.exists)
        
        app.buttons.firstMatch.tap()
        sleep(1)

        XCTAssertEqual(app.staticTexts.count, 3)
        XCTAssertEqual(app.staticTexts.allElementsBoundByIndex.filter { $0.label == "0.0" }.count, 2)
        XCTAssertEqual(app.staticTexts.allElementsBoundByIndex.filter { $0.label == "PlaceHolder" }.count, 1)
        XCTAssertFalse(app.images.firstMatch.exists)

        app.buttons.firstMatch.tap()
        sleep(1)

        XCTAssertEqual(app.staticTexts.count, 3)
        XCTAssertEqual(app.staticTexts.allElementsBoundByIndex.filter { $0.label == "0.5" }.count, 2)
        XCTAssertEqual(app.staticTexts.allElementsBoundByIndex.filter { $0.label == "PlaceHolder" }.count, 1)
        XCTAssertFalse(app.images.firstMatch.exists)

        app.buttons.firstMatch.tap()
        sleep(1)

        XCTAssertFalse(app.staticTexts.firstMatch.exists)
        XCTAssertEqual(app.images.count, 4)

        app.buttons.firstMatch.tap()
        sleep(1)

        XCTAssertEqual(app.staticTexts.count, 3)
        XCTAssertEqual(app.staticTexts.allElementsBoundByIndex.filter { $0.label == "0.0" }.count, 2)
        XCTAssertEqual(app.staticTexts.allElementsBoundByIndex.filter { $0.label == "PlaceHolder" }.count, 1)
        XCTAssertFalse(app.images.firstMatch.exists)

        app.buttons.firstMatch.tap()
        sleep(1)

        XCTAssertFalse(app.staticTexts.firstMatch.exists)
        XCTAssertEqual(app.images.count, 4)

        app.buttons.firstMatch.tap()
        sleep(1)

        XCTAssertEqual(app.staticTexts.count, 3)
        XCTAssertEqual(app.staticTexts.allElementsBoundByIndex.filter { $0.label == "0.0" }.count, 2)
        XCTAssertEqual(app.staticTexts.allElementsBoundByIndex.filter { $0.label == "PlaceHolder" }.count, 1)
        XCTAssertFalse(app.images.firstMatch.exists)

        app.buttons.firstMatch.tap()
        sleep(1)

        XCTAssertEqual(app.staticTexts.count, 3)
        XCTAssertEqual(app.staticTexts.allElementsBoundByIndex.filter { $0.label == "The operation couldn’t be completed. (AppForUITest.ContentView.Errors error 0.)" }.count, 2)
        XCTAssertEqual(app.staticTexts.allElementsBoundByIndex.filter { $0.label == "PlaceHolder" }.count, 1)
        XCTAssertFalse(app.images.firstMatch.exists)
    }
}
