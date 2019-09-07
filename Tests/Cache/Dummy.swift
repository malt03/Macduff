//
//  Dummy.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/07.
//

import Foundation
@testable import Macduff

struct DummyImageProvider: ImageProvider {
    let cacheKey: String
    func run(progress: @escaping (Float) -> Void, success: @escaping (ProvidingImage) -> Void, failure: @escaping (Error) -> Void) {}
}

struct DummyImageProcessor: ImageProcessor {
    let cacheKey: String
    func process(image: NativeImage) -> NativeImage? { nil }
}
