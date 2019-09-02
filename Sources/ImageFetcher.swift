//
//  ImageFetcher.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation
import Combine

final class ImageFetcher: ObservableObject {
    @Published var progress: Float = 0
    @Published var image: NativeImage? = nil
    @Published var error: Error? = nil
    
    private let provider: ImageProvider
    private let config: Config

    private var cancellables = Set<AnyCancellable>()
    
    init(provider: ImageProvider, config: Config = .default) {
        self.provider = provider
        self.config = config
    }
    
    convenience init(source: Source, config: Config = .default) {
        self.init(provider: source.provider, config: config)
    }
    
    func fetch(completion: ((Status) -> Void)?) {
        if error != nil { error = nil }
        config.cache.getOrStore(key: provider.cacheKey, ttl: config.cacheTTL, fetch: { (fetchedHandler) in
            self.provider.run(progress: {
                self.progress = $0
            }, success: {
                fetchedHandler($0)
            }, failure: {
                self.error = $0
                completion?(.failure($0))
            })
        }, result: {
            self.image = $0
            completion?(.success($0))
        })
    }
}
