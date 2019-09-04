//
//  ImageFetcher.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation
import Combine

public final class ImageFetcher: ObservableObject {
    @Published var progress: Float = 0
    @Published var image: NativeImage? = nil
    @Published var error: Error? = nil
    
    private let provider: ImageProvider
    private let config: Config

    private var cancellables = Set<AnyCancellable>()
    
    public init(provider: ImageProvider, config: Config = .default) {
        self.provider = provider
        self.config = config
    }
    
    public convenience init(source: Source, config: Config = .default) {
        self.init(provider: source.provider, config: config)
    }
    
    public func fetch(completion: ((Status) -> Void)?) {
        if error != nil { error = nil }
        config.cache.getOrStore(key: provider.hashedCacheKey, ttl: config.cacheTTL, provide: { (fetchedHandler) in
            self.provider.run(progress: { (progress) in
                DispatchQueue.main.async { self.progress = progress }
            }, success: {
                fetchedHandler($0)
            }, failure: { (error) in
                DispatchQueue.main.async {
                    self.error = error
                    completion?(.failure(error))
                }
            })
        }, result: { (image) in
            DispatchQueue.main.async {
                self.image = image
                completion?(.success(image))
            }
        })
    }
}
