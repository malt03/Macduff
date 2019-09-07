//
//  MemoryCacheTest.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/07.
//

import XCTest
@testable import Macduff

final class MemoryCacheTest: XCTestCase {
    override func tearDown() {
        unfixDate()
        
        super.tearDown()
    }
    
    func test() {
        let cache = MemoryCache(fallbackCache: nil)
        
        let now = Date(timeIntervalSince1970: 1000)
        fixDate(now)
        
        let image = getImage(resourceName: "Lena")
        let data = image.pngData()!
        let blurImage = getImage(resourceName: "BlurLena")
        let blurData = blurImage.pngData()!

        do {
            let expectationProvide = expectation(description: "")
            let expectationResult = expectation(description: "")
            cache.getOrStore(key: key("1", "1"), ttl: 60, provide: { (provided) in
                provided(ProvidingImage(image: image, originalData: data))
                expectationProvide.fulfill()
            }, result: { (resultImage) in
                XCTAssertEqual(resultImage, image)
                expectationResult.fulfill()
            })
            waitForExpectations(timeout: 1, handler: nil)
        }
        
        do {
            let expectationProvide = expectation(description: "")
            let expectationResult = expectation(description: "")
            cache.getOrStore(key: key("1", "2"), ttl: 60, provide: { (provided) in
                provided(ProvidingImage(image: image, originalData: data))
                expectationProvide.fulfill()
            }, result: { (resultImage) in
                expectationResult.fulfill()
            })
            waitForExpectations(timeout: 1, handler: nil)
        }
        
        do {
            let expectationProvide = expectation(description: "")
            let expectationResult = expectation(description: "")
            cache.getOrStore(key: key("2", "1"), ttl: 60, provide: { (provided) in
                provided(ProvidingImage(image: image, originalData: data))
                expectationProvide.fulfill()
            }, result: { (resultImage) in
                expectationResult.fulfill()
            })
            waitForExpectations(timeout: 1, handler: nil)
        }

        
        fixDate(now.addingTimeInterval(60))
        
        do {
            let expectationResult = expectation(description: "")
            cache.getOrStore(key: key("1", "1"), ttl: 60, provide: { (provided) in
                XCTAssert(false)
            }, result: { (resultImage) in
                XCTAssertNotEqual(resultImage, image)
                XCTAssertEqual(resultImage.pngData(), image.pngData())
                expectationResult.fulfill()
            })
            waitForExpectations(timeout: 1, handler: nil)
        }
        
        fixDate(now.addingTimeInterval(61))
        
        do {
            let expectationProvide = expectation(description: "")
            let expectationResult = expectation(description: "")
            cache.getOrStore(key: key("1", "1"), ttl: 60, provide: { (provided) in
                provided(ProvidingImage(image: blurImage, originalData: blurData))
                expectationProvide.fulfill()
            }, result: { (resultImage) in
                XCTAssertEqual(resultImage, blurImage)
                expectationResult.fulfill()
            })
            waitForExpectations(timeout: 1, handler: nil)
        }
        
        cache.clean()

        do {
            let expectationResult = expectation(description: "")
            cache.getOrStore(key: key("1", "1"), ttl: 60, provide: { (provided) in
                XCTAssert(false)
            }, result: { (resultImage) in
                expectationResult.fulfill()
            })
            waitForExpectations(timeout: 1, handler: nil)
        }

        #if os(iOS)
        NotificationCenter.default.post(name: UIApplication.didReceiveMemoryWarningNotification, object: nil)

        do {
            let expectationProvide = expectation(description: "")
            let expectationResult = expectation(description: "")
            cache.getOrStore(key: key("1", "1"), ttl: 60, provide: { (provided) in
                provided(ProvidingImage(image: blurImage, originalData: blurData))
                expectationProvide.fulfill()
            }, result: { (resultImage) in
                XCTAssertEqual(resultImage, blurImage)
                expectationResult.fulfill()
            })
            waitForExpectations(timeout: 1, handler: nil)
        }
        #endif
    }
}
