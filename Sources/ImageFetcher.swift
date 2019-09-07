//
//  ImageFetcher.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/03.
//

import SwiftUI
import Combine

public final class ImageFetcher: ObservableObject {
    @Published var progress: Float = 0
    @Published var image: NativeImage? = nil
    @Published var error: Error? = nil
    
    private let provider: ImageProvider?
    private let config: Config

    private var cancellables = Set<AnyCancellable>()
    
    public init(provider: ImageProvider?, config: Config = .default) {
        self.provider = provider
        self.config = config
    }
    
    public convenience init(source: Source, config: Config = .default) {
        self.init(provider: source.provider, config: config)
    }
    
    public func fetch(completion: ((Status) -> Void)?) {
        progress = 0
        image = nil
        error = nil

        guard let provider = provider else { return }
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
                    completion?(.failure(error))
                }
            })
        }, result: { (image) in
            DispatchQueue.main.async {
                withAnimation { self.image = image }
                completion?(.success(image))
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
