//
//  RemoteURLImageProvider.swift
//  MacduffTests-iOS
//
//  Created by Koji Murata on 2019/09/07.
//

import XCTest
import Nocilla
@testable import Macduff

final class URLImageProviderTest: XCTestCase {
    override class func setUp() {
        super.setUp()
        LSNocilla.sharedInstance()?.start()
    }
    
    override class func tearDown() {
        LSNocilla.sharedInstance()?.stop()
        super.tearDown()
    }
    
    func test() {
        let url = URL(string: "http://example.com")!
        let data = getImage(resourceName: "Lena").pngData()!
        
        stubRequest(for: url, data: data, withSize: true)
        
        let expectation = self.expectation(description: "")
        var progress = 0 as Float
        
        XCTAssertEqual(url.provider.cacheKey, "http://example.com")
        url.provider.run(progress: {
            progress = $0
        }, success: { (image) in
            XCTAssertEqual(image.originalData, data)
            expectation.fulfill()
        }, failure: { _ in
            XCTAssert(false)
        })
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(progress, 1)
    }
}
