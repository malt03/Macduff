//
//  Dummy.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/07.
//

import XCTest
@testable import Macduff

struct DummyImageProvider: ImageProvider {
    let cacheKey: String
    func run(progress: @escaping (Float) -> Void, success: @escaping (ProvidingImage) -> Void, failure: @escaping (Error) -> Void) {}
}

struct DummyImageProcessor: ImageProcessor {
    let cacheKey: String
    func process(image: NativeImage) -> NativeImage? { nil }
}

extension XCTestCase {
    func key(_ provider: String, _ processor: String) -> CacheKey {
        CacheKey(provider: DummyImageProvider(cacheKey: provider), processor: DummyImageProcessor(cacheKey: processor))
    }
}
