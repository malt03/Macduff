//
//  DiskCacheTest.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/07.
//

import XCTest
@testable import Macduff

final class DiskCacheTest: XCTestCase {
    override func tearDown() {
        unfixDate()
        
        super.tearDown()
    }
    
    func test() {
        let cache = DiskCache()!
        defer { try! cache.removeAll() }
        
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
        
        #if os(iOS)
        let cachedURLsBeforeClean = try! FileManager.default.contentsOfDirectory(
            at: DiskCache.defaultCacheDirectory!,
            includingPropertiesForKeys: nil,
            options: []
        )
        XCTAssertEqual(cachedURLsBeforeClean.count, 3)
        
        NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification, object: nil)
        sleep(1)
        
        let cachedURLsAfterClean = try! FileManager.default.contentsOfDirectory(
            at: DiskCache.defaultCacheDirectory!,
            includingPropertiesForKeys: nil,
            options: []
        )
        XCTAssertEqual(cachedURLsAfterClean.count, 1)
        
        let hashedKey = "2075374f4851de52765ef275fdd273b911a2f8a28fc1d4e1b46e6cba908f7332"
        XCTAssertEqual(cachedURLsAfterClean[0].lastPathComponent, hashedKey)

        let info = DiskCache.defaultCacheDirectory!.appendingPathComponent(hashedKey).appendingPathComponent("info.json")
        try! FileManager.default.removeItem(at: info)

        NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification, object: nil)
        sleep(1)

        let cachedURLsAfterCleanAll = try! FileManager.default.contentsOfDirectory(
            at: DiskCache.defaultCacheDirectory!,
            includingPropertiesForKeys: nil,
            options: []
        )
        XCTAssertEqual(cachedURLsAfterCleanAll.count, 0)
        #endif
        
        try! cache.removeAll()
        let cachedURLsAfterRemoveAll = try! FileManager.default.contentsOfDirectory(
            at: DiskCache.defaultCacheDirectory!,
            includingPropertiesForKeys: nil,
            options: []
        )
        XCTAssertEqual(cachedURLsAfterRemoveAll.count, 0)
    }
    
    func key(_ provider: String, _ processor: String) -> CacheKey {
        CacheKey(provider: DummyImageProvider(cacheKey: provider), processor: DummyImageProcessor(cacheKey: processor))
    }
}
