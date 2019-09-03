//
//  Cache.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation

public protocol Cache: class {
    func store(image: ExpirableImage, for key: String)
    func get(for key: String) -> NativeImage?
    var fallbackCache: Cache? { get }
}

extension Cache {
    private var queue: DispatchQueue { return DispatchQueue(label: "com.malt03.RemoteImage.ImageCache") }
    
    func getOrStore(
        key: String,
        ttl: TimeInterval,
        fetch: @escaping (@escaping (NativeImage?) -> Void) -> Void,
        result: @escaping (NativeImage) -> Void
    ) {
        queue.async {
            if let cached = self.get(for: key) ?? self.fallbackCache?.get(for: key) {
                result(cached)
                return
            }

            fetch { (fetched) in
                guard let fetched = fetched else { return }
                let expirable = fetched.withExpiresAt(Date().addingTimeInterval(ttl))
                self.store(image: expirable, for: key)
                self.fallbackCache?.store(image: expirable, for: key)
                result(fetched)
            }
        }
    }
}
