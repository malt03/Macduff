//
//  Cache.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation

protocol Cache {
    func store(image: NativeImage, for key: String, expiresAt: Date)
    func get(for key: String) -> NativeImage?
    var wrapped: Cache? { get }
}

extension Cache {
    private var queue: DispatchQueue { return DispatchQueue(label: "com.malt03.RemoteImage.ImageCache") }
    
    func getOrStore(
        key: String,
        ttl: TimeInterval,
        fetch: @escaping ((NativeImage?) -> Void) -> Void,
        result: @escaping (NativeImage) -> Void
    ) {
        queue.async {
            if let cached = self.wrapped?.get(for: key) ?? self.get(for: key) {
                DispatchQueue.main.async { result(cached) }
                return
            }

            fetch { (fetched) in
                guard let fetched = fetched else { return }
                let expiresAt = Date().addingTimeInterval(ttl)
                self.store(image: fetched, for: key, expiresAt: expiresAt)
                self.wrapped?.store(image: fetched, for: key, expiresAt: expiresAt)
                result(fetched)
            }
        }
    }
}
