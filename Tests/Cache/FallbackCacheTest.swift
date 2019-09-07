//
//  FallbackCacheTest.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/07.
//

import XCTest
@testable import Macduff

final class FallbackCacheTest: XCTestCase {
    private final class FixCache: Cache {
        var dict: [String: CacheImage]
        let fallbackCache: Cache?
        
        var storeCalled = false
        var getCalled = false
        
        fileprivate func reset() {
            storeCalled = false
            getCalled = false
        }
        
        init(dict: [String: CacheImage], fallbackCache: Cache?) {
            self.dict = dict
            self.fallbackCache = fallbackCache
        }

        func store(image: CacheImage, for key: String) {
            storeCalled = true
        }
        
        func get(for key: String) -> CacheImage? {
            getCalled = true
            return dict[key]
        }
    }
    
    
    func test() {
        let key0 = key("0", "0")
        let key1 = key("1", "1")
        let key2 = key("2", "2")
        let info = CacheImage.Info(expiresAt: Date().addingTimeInterval(60))
        let image = getImage(resourceName: "Lena")
        let data = image.pngData()!
        let cacheImage = CacheImage(originalData: data, info: info)
        let providingImage = ProvidingImage(image: image, originalData: data)
        
        let fallbackCache = FixCache(dict: [key0.generate()!: cacheImage], fallbackCache: nil)
        let mainCache = FixCache(dict: [key1.generate()!: cacheImage], fallbackCache: fallbackCache)
        
        mainCache.getOrStore(key: key0, ttl: 0, provide: { $0(providingImage) }, result: { _ in })
        
        usleep(100_000)
        
        XCTAssertTrue(mainCache.getCalled)
        XCTAssertTrue(fallbackCache.getCalled)
        XCTAssertTrue(mainCache.storeCalled)
        XCTAssertFalse(fallbackCache.storeCalled)
        
        mainCache.reset()
        fallbackCache.reset()

        mainCache.getOrStore(key: key1, ttl: 0, provide: { $0(providingImage) }, result: { _ in })

        usleep(100_000)
        
        XCTAssertTrue(mainCache.getCalled)
        XCTAssertFalse(fallbackCache.getCalled)
        XCTAssertFalse(mainCache.storeCalled)
        XCTAssertFalse(fallbackCache.storeCalled)

        mainCache.reset()
        fallbackCache.reset()

        mainCache.getOrStore(key: key2, ttl: 0, provide: { $0(providingImage) }, result: { _ in })

        usleep(1000_000)
        
        XCTAssertTrue(mainCache.getCalled)
        XCTAssertTrue(fallbackCache.getCalled)
        XCTAssertTrue(mainCache.storeCalled)
        XCTAssertTrue(fallbackCache.storeCalled)
    }
}
