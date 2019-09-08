//
//  ImageFetcherTest.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/08.
//

import XCTest
import Combine
@testable import Macduff

final class ImageFetcherTest: XCTestCase {
    private final class Provider: ImageProvider {
        var cacheKey: String { "dummy" }
        
        var progress: ((Float) -> Void)?
        var success: ((ProvidingImage) -> Void)?
        var failure: ((Error) -> Void)?
        
        func run(progress: @escaping (Float) -> Void, success: @escaping (ProvidingImage) -> Void, failure: @escaping (Error) -> Void) {
            self.progress = progress
            self.success = success
            self.failure = failure
        }
    }
    
    private struct Source: Macduff.Source {
        let provider: ImageProvider
    }
    
    private struct Processor: ImageProcessor {
        var cacheKey: String { "dummy" }
        
        func process(image: NativeImage) -> NativeImage? { image }
    }
    
    private struct NilProcessor: ImageProcessor {
        var cacheKey: String { "nil" }
        
        func process(image: NativeImage) -> NativeImage? { nil }
    }
    
    func testSuccess() {
        let config = Config(cache: MemoryCache(fallbackCache: nil), imageProcessor: Processor())
        
        let expectedImage = getImage(resourceName: "Lena")

        do {
            let provider = Provider()
            let source = Source(provider: provider)
            let fetcher = ImageFetcher(with: source, config: config)
            
            XCTAssertNil(provider.progress)
            XCTAssertNil(provider.success)
            XCTAssertNil(provider.failure)
            
            var fetchedImage: NativeImage?
            
            fetcher.fetch { (status) in
                switch status {
                case .success(let image):
                    fetchedImage = image
                case .failure:
                    XCTAssert(false)
                }
            }
            
            XCTAssertNil(fetchedImage)
            
            do {
                var progress = 0 as Float
                let expectation = self.expectation(description: "")
                expectation.expectedFulfillmentCount = 2
                let cancellable = fetcher.$progress.sink {
                    progress = $0
                    expectation.fulfill()
                }
                XCTAssertEqual(progress, 0)
                provider.progress?(1)
                waitForExpectations(timeout: 1, handler: nil)
                XCTAssertEqual(progress, 1)
                cancellable.cancel()
            }
            
            do {
                var image: NativeImage?
                let expectation = self.expectation(description: "")
                expectation.expectedFulfillmentCount = 2
                let cancellable = fetcher.$image.sink {
                    image = $0
                    expectation.fulfill()
                }
                XCTAssertNil(image)
                usleep(100_000)
                provider.success?(ProvidingImage(image: expectedImage, originalData: nil))
                waitForExpectations(timeout: 1, handler: nil)
                XCTAssertEqual(image, expectedImage)
                XCTAssertEqual(fetchedImage, expectedImage)
                cancellable.cancel()
            }
        }
        
        do {
            let provider = Provider()
            let fetcher = ImageFetcher(with: provider, config: config)
            
            XCTAssertNil(provider.progress)
            XCTAssertNil(provider.success)
            XCTAssertNil(provider.failure)
            
            var fetchedImage: NativeImage?
            
            let expectation = self.expectation(description: "")
            fetcher.fetch { (status) in
                switch status {
                case .success(let image):
                    fetchedImage = image
                    expectation.fulfill()
                case .failure:
                    XCTAssert(false)
                }
            }
            waitForExpectations(timeout: 0.1, handler: nil)
            XCTAssertEqual(fetchedImage?.pngData(), expectedImage.pngData())
        }
    }
    
    func testNilProcessor() {
        let config = Config(cache: MemoryCache(fallbackCache: nil), imageProcessor: NilProcessor())

        let expectedImage = getImage(resourceName: "Lena")

        let provider = Provider()
        let source = Source(provider: provider)
        let fetcher = ImageFetcher(with: source, config: config)
        
        XCTAssertNil(provider.progress)
        XCTAssertNil(provider.success)
        XCTAssertNil(provider.failure)
        
        var fetchedImage: NativeImage?
        
        fetcher.fetch { (status) in
            switch status {
            case .success(let image):
                fetchedImage = image
            case .failure:
                XCTAssert(false)
            }
        }
        
        XCTAssertNil(fetchedImage)
        
        var image: NativeImage?
        let expectation = self.expectation(description: "")
        expectation.expectedFulfillmentCount = 2
        let cancellable = fetcher.$image.sink {
            image = $0
            expectation.fulfill()
        }
        XCTAssertNil(image)
        usleep(100_000)
        provider.success?(ProvidingImage(image: expectedImage, originalData: nil))
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertEqual(image, expectedImage)
        XCTAssertEqual(fetchedImage, expectedImage)
        cancellable.cancel()
    }
    
    func testWithoutProcessor() {
        let config = Config(cache: MemoryCache(fallbackCache: nil))

        let expectedImage = getImage(resourceName: "Lena")

        let provider = Provider()
        let source = Source(provider: provider)
        let fetcher = ImageFetcher(with: source, config: config)

        XCTAssertNil(provider.progress)
        XCTAssertNil(provider.success)
        XCTAssertNil(provider.failure)

        var fetchedImage: NativeImage?

        fetcher.fetch { (status) in
            switch status {
            case .success(let image):
                fetchedImage = image
            case .failure:
                XCTAssert(false)
            }
        }

        XCTAssertNil(fetchedImage)

        var image: NativeImage?
        let expectation = self.expectation(description: "")
        expectation.expectedFulfillmentCount = 2
        let cancellable = fetcher.$image.sink {
            image = $0
            expectation.fulfill()
        }
        XCTAssertNil(image)
        usleep(100_000)
        provider.success?(ProvidingImage(image: expectedImage, originalData: nil))
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertEqual(image, expectedImage)
        XCTAssertEqual(fetchedImage, expectedImage)
        cancellable.cancel()
    }
    
    enum Errors: Error {
        case dummy
    }
    
    func testFailure() {
        let config = Config(cache: MemoryCache(fallbackCache: nil), imageProcessor: Processor())

        let provider = Provider()
        let source = Source(provider: provider)
        let fetcher = ImageFetcher(with: source, config: config)
        
        XCTAssertNil(provider.progress)
        XCTAssertNil(provider.success)
        XCTAssertNil(provider.failure)
        
        var fetchedError: Error?
        
        fetcher.fetch { (status) in
            switch status {
            case .success:
                XCTAssert(false)
            case .failure(let error):
                fetchedError = error
            }
        }
        
        XCTAssertNil(fetchedError)
        
        var error: Error?
        let expectation = self.expectation(description: "")
        expectation.expectedFulfillmentCount = 2
        let cancellable = fetcher.$error.sink {
            error = $0
            expectation.fulfill()
        }
        XCTAssertNil(error)
        provider.failure?(Errors.dummy)
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertEqual(error as! Errors, Errors.dummy)
        XCTAssertEqual(fetchedError as! Errors, Errors.dummy)
        cancellable.cancel()
    }
    
    func testNil() {
        let fetcher = ImageFetcher(with: nil)
        
        fetcher.fetch { _ in
            XCTAssert(false)
        }
        
        usleep(100_000)
    }
}
