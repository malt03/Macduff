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
        
        return ZStack<TupleView<(Image?, LoadingPlaceHolder?, ErrorPlaceHolder?)>> {
            imageView
            loadingPlaceHolder
            errorPlaceHolder
        }.onAppear {
            self.imageFetcher.fetch(completion: self.completionHandler)
        }
    }
}
