//
//  ImageDownloaderTest.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/07.
//

import XCTest
import Nocilla
@testable import Macduff

final class ImageDownloaderTest: XCTestCase {
    override class func setUp() {
        super.setUp()
        LSNocilla.sharedInstance()?.start()
    }
    
    override class func tearDown() {
        LSNocilla.sharedInstance()?.stop()
        super.tearDown()
    }
    
    func testSuccess() {
        let url = URL(string: "http://example.com")!
        let data = getImage(resourceName: "Lena").pngData()!

        stubRequest(for: url, data: data, withSize: true)
        
        let expectation = self.expectation(description: "")
        var progress = 0 as Float
        
        ImageDownloader(url: url, progress: {
            progress = $0
        }, success: { (image) in
            XCTAssertEqual(image.originalData, data)
            expectation.fulfill()
        }, failure: { _ in
            XCTAssert(false)
        }).download()
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(progress, 1)
    }
    
    func testSuccessWithoutSize() {
        let url = URL(string: "http://example.com")!
        let data = getImage(resourceName: "Lena").pngData()!

        stubRequest(for: url, data: data, withSize: false)
        
        let expectation = self.expectation(description: "")
        
        ImageDownloader(url: url, progress: { _ in
            XCTAssert(false)
        }, success: { (image) in
            XCTAssertEqual(image.originalData, data)
            expectation.fulfill()
        }, failure: { _ in
            XCTAssert(false)
        }).download()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFailureResponse() {
        let url = URL(string: "http://example.com")!

        stubRequestError(for: url, code: 404)
        
        let expectation = self.expectation(description: "")
        
        ImageDownloader(url: url, progress: { _ in
            XCTAssert(false)
        }, success: { _ in
            XCTAssert(false)
        }, failure: { _ in
            expectation.fulfill()
        }).download()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testInvalidData() {
        let url = URL(string: "http://example.com")!

        stubRequest(for: url, data: Data(repeating: 1, count: 1), withSize: true)

        let expectation = self.expectation(description: "")
        
        var progress = 0 as Float
        ImageDownloader(url: url, progress: {
            progress = $0
        }, success: { _ in
            XCTAssert(false)
        }, failure: { _ in
            expectation.fulfill()
        }).download()
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(progress, 1)
    }
}
