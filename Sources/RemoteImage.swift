//
//  RemoteImage.swift
//  RemoteImage
//
//  Created by Koji Murata on 2019/09/02.
//

import SwiftUI

public struct RemoteImage<LoadingPlaceHolder: View, ErrorPlaceHolder: View> {
    public enum FetchTrigger {
        case initialize
        case appear
    }
    
    @ObservedObject private var imageFetcher: ImageFetcher

    private let fetchTrigger: FetchTrigger
    private let completionHandler: ((Status) -> Void)?
    private let loadingPlaceHolderHandler: ((Float) -> LoadingPlaceHolder)?
    private let errorPlaceHolderHandler: ((Error) -> ErrorPlaceHolder)?
    
    public init(
        provider: ImageProvider,
        loadingPlaceHolder: ((Float) -> LoadingPlaceHolder)? = nil,
        errorPlaceHolder: ((Error) -> ErrorPlaceHolder)? = nil,
        config: Config = .default,
        fetchTrigger: FetchTrigger = .appear,
        completion: ((Status) -> Void)? = nil
    ) {
        imageFetcher = ImageFetcher(provider: provider, config: config)
        loadingPlaceHolderHandler = loadingPlaceHolder
        errorPlaceHolderHandler = errorPlaceHolder
        
        self.fetchTrigger = fetchTrigger
        completionHandler = completion
        
        if fetchTrigger == .initialize {
            self.fetch()
        }
    }
    
    public init(
        source: Source,
        loadingPlaceHolder: ((Float) -> LoadingPlaceHolder)? = nil,
        errorPlaceHolder: ((Error) -> ErrorPlaceHolder)? = nil,
        config: Config = .default,
        fetchTrigger: FetchTrigger = .appear,
        completion: ((Status) -> Void)? = nil
    ) {
        self.init(
            provider: source.provider,
            loadingPlaceHolder: loadingPlaceHolder,
            errorPlaceHolder: errorPlaceHolder,
            config: config,
            fetchTrigger: fetchTrigger,
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
        }
    }
}
