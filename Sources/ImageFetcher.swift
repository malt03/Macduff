//
//  ImageFetcher.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/03.
//

import SwiftUI
import Combine

public final class ImageFetcher: ObservableObject {
    private enum FetchState {
        case notStarted
        case started
        case finished
    }
    
    enum Errors: LocalizedError {
        case alreadyFetching
        var errorDescription: String? { "Already Fetching" }
    }
    
    @Published public private(set) var progress: Float = 0
    @Published public private(set) var image: NativeImage? = nil
    @Published public private(set) var error: Error? = nil
    
    private let provider: ImageProvider?
    private let config: Config
    
    private var fetchState = FetchState.notStarted
    private let fetchLock = NSLock()

    private var cancellables = Set<AnyCancellable>()
    
    public init(with provider: ImageProvider?, config: Config = .default) {
        self.provider = provider
        self.config = config
    }
    
    public convenience init(with source: Source, config: Config = .default) {
        self.init(with: source.provider, config: config)
    }
    
    public func fetch(completion: ((Status) -> Void)?) {
        fetchLock.lock()
        defer { fetchLock.unlock() }
        
        if fetchState != .notStarted && fetchState != .finished {
            completion?(.failure(Errors.alreadyFetching))
            return
        }

        progress = 0
        image = nil
        error = nil

        guard let provider = provider else { return }

        fetchState = .started
        func complete(status: Status) {
            fetchState = .finished
            completion?(status)
        }

        let key = CacheKey(provider: provider, processor: config.imageProcessor)
        config.cache.getOrStore(key: key, ttl: config.cacheTTL, provide: { (provided) in
            provider.run(progress: { (progress) in
                DispatchQueue.main.async {
                    withAnimation { self.progress = progress }
                }
            }, success: { (image) in
                if let processor = self.config.imageProcessor {
                    processor.processAsync(image: image, completion: provided)
                } else {
                    provided(image)
                }
            }, failure: { (error) in
                DispatchQueue.main.async {
                    withAnimation { self.error = error }
                    complete(status: .failure(error))
                }
            })
        }, result: { (image) in
            DispatchQueue.main.async {
                withAnimation { self.image = image }
                complete(status: .success(image))
            }
        })
    }
}

extension ImageProcessor {
    fileprivate func processAsync(image: ProvidingImage, completion: @escaping (ProvidingImage) -> Void) {
        DispatchQueue.global().async {
            guard
                let processedImage = self.process(image: image.image)
                else {
                    completion(image)
                    return
                }
            completion(ProvidingImage(image: processedImage, originalData: processedImage.pngData()))
        }
    }
}
