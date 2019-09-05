//
//  RemoteImage.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/02.
//

import SwiftUI

public struct RemoteImage<ImageView: View, LoadingPlaceHolder: View, ErrorPlaceHolder: View> {
    @ObservedObject private var imageFetcher: ImageFetcher

    private let completionHandler: ((Status) -> Void)?
    private let imageViewHandler: (NativeImage) -> ImageView
    private let loadingPlaceHolderHandler: ((Float) -> LoadingPlaceHolder)?
    private let errorPlaceHolderHandler: ((Error) -> ErrorPlaceHolder)?
    private let transition: AnyTransition
    private let fetchTrigger: Config.FetchTrigger

    init(
        with provider: ImageProvider,
        imageView: @escaping (NativeImage) -> ImageView,
        loadingPlaceHolder: ((Float) -> LoadingPlaceHolder)?,
        errorPlaceHolder: ((Error) -> ErrorPlaceHolder)?,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        imageFetcher = ImageFetcher(provider: provider, config: config)
        
        imageViewHandler = imageView
        loadingPlaceHolderHandler = loadingPlaceHolder
        errorPlaceHolderHandler = errorPlaceHolder
        
        completionHandler = completion
        
        transition = config.transition
        fetchTrigger = config.fetchTrigger

        if fetchTrigger == .initialize {
            self.fetch()
        }
    }
    
    init(
        with source: Source,
        imageView: @escaping (NativeImage) -> ImageView,
        loadingPlaceHolder: ((Float) -> LoadingPlaceHolder)?,
        errorPlaceHolder: ((Error) -> ErrorPlaceHolder)?,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        self.init(
            with: source.provider,
            imageView: imageView,
            loadingPlaceHolder: loadingPlaceHolder,
            errorPlaceHolder: errorPlaceHolder,
            config: config,
            completion: completion
        )
    }
    
    private func fetch() {
        if self.imageFetcher.image != nil { return }
        imageFetcher.fetch(completion: completionHandler)
    }
}

extension RemoteImage: View {
    public var body: some View {
        var imageView: ImageView? = nil
        var loadingPlaceHolder: LoadingPlaceHolder? = nil
        var errorPlaceHolder: ErrorPlaceHolder? = nil
        
        if let image = imageFetcher.image {
            imageView = imageViewHandler(image)
        } else if let error = imageFetcher.error {
            errorPlaceHolder = errorPlaceHolderHandler?(error)
        } else {
            loadingPlaceHolder = loadingPlaceHolderHandler?(imageFetcher.progress)
        }
        
        return TupleView((
            imageView,
            loadingPlaceHolder,
            errorPlaceHolder
        )).onAppear {
            if self.fetchTrigger == .appear { self.fetch() }
        }.transition(transition)
    }
}
