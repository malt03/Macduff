//
//  RemoteImage.swift
//  RemoteImage
//
//  Created by Koji Murata on 2019/09/02.
//

import SwiftUI

public struct RemoteImage<LoadingPlaceHolder: View, ErrorPlaceHolder: View> {
    @ObservedObject private var imageFetcher: ImageFetcher

    private let completionHandler: ((Status) -> Void)?
    private let loadingPlaceHolderHandler: ((Float) -> LoadingPlaceHolder)?
    private let errorPlaceHolderHandler: ((Error) -> ErrorPlaceHolder)?
    private let transition: AnyTransition
    private let fetchTrigger: Config.FetchTrigger

    public init(
        provider: ImageProvider,
        loadingPlaceHolder: ((Float) -> LoadingPlaceHolder)? = nil,
        errorPlaceHolder: ((Error) -> ErrorPlaceHolder)? = nil,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        imageFetcher = ImageFetcher(provider: provider, config: config)
        loadingPlaceHolderHandler = loadingPlaceHolder
        errorPlaceHolderHandler = errorPlaceHolder
        
        completionHandler = completion
        
        transition = config.transition
        fetchTrigger = config.fetchTrigger

        if fetchTrigger == .initialize {
            self.fetch()
        }
    }
    
    public init(
        source: Source,
        loadingPlaceHolder: ((Float) -> LoadingPlaceHolder)? = nil,
        errorPlaceHolder: ((Error) -> ErrorPlaceHolder)? = nil,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        self.init(
            provider: source.provider,
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
        var imageView: Image? = nil
        var loadingPlaceHolder: LoadingPlaceHolder? = nil
        var errorPlaceHolder: ErrorPlaceHolder? = nil
        
        if let image = imageFetcher.image {
            imageView = Image(nativeImage: image)
        } else if let error = imageFetcher.error {
            errorPlaceHolder = errorPlaceHolderHandler?(error)
        } else {
            loadingPlaceHolder = loadingPlaceHolderHandler?(imageFetcher.progress)
        }
        
        return TupleView((
            imageView?.resizable(),
            loadingPlaceHolder,
            errorPlaceHolder
        )).onAppear {
            if self.fetchTrigger == .appear { self.fetch() }
        }.transition(transition)
    }
}
