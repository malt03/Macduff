//
//  RemoteImageContent.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/06.
//

import SwiftUI

struct RemoteImageContent<ImageView: View, LoadingPlaceHolder: View, ErrorPlaceHolder: View> {
    @ObservedObject private var imageFetcher: ImageFetcher

    private let completionHandler: ((Status) -> Void)?
    private let imageViewHandler: (NativeImage) -> ImageView
    private let loadingPlaceHolderHandler: ((Float) -> LoadingPlaceHolder)?
    private let errorPlaceHolderHandler: ((Error) -> ErrorPlaceHolder)?
    private let transition: AnyTransition
    private let fetchTrigger: Config.FetchTrigger

    init(
        with provider: ImageProvider?,
        imageView: @escaping (NativeImage) -> ImageView,
        loadingPlaceHolder: ((Float) -> LoadingPlaceHolder)?,
        errorPlaceHolder: ((Error) -> ErrorPlaceHolder)?,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        imageFetcher = ImageFetcher(with: provider, config: config)
        
        imageViewHandler = imageView
        loadingPlaceHolderHandler = loadingPlaceHolder
        errorPlaceHolderHandler = errorPlaceHolder
        
        completionHandler = completion
        
        transition = config.transition
        fetchTrigger = config.fetchTrigger

        if fetchTrigger.contains(.onInitialize) {
            self.fetch()
        }
    }

    private func fetch() {
        if self.imageFetcher.image != nil { return }
        imageFetcher.fetch { (status) in
            guard let completionHandler = self.completionHandler else { return }
            switch status {
            case .success: completionHandler(status)
            case .failure(let error):
                if let error = error as? ImageFetcher.Errors, error == .alreadyFetching { return }
                completionHandler(status)
            }
        }
    }
}

extension RemoteImageContent: View {
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
        
        return ZStack {
            imageView.transition(transition)
            loadingPlaceHolder.transition(transition)
            errorPlaceHolder.transition(transition)
        }.onAppear {
            if self.fetchTrigger.contains(.onAppear) { self.fetch() }
        }
    }
}

