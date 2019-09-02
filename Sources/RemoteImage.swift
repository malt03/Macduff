//
//  RemoteImage.swift
//  RemoteImage
//
//  Created by Koji Murata on 2019/09/02.
//

import SwiftUI

struct RemoteImage<LoadingPlaceHolder: View, ErrorPlaceHolder: View> {
    @ObservedObject private var imageFetcher: ImageFetcher
    
    private let completionHandler: ((Status) -> Void)?
    private let loadingPlaceHolderHandler: ((Float) -> LoadingPlaceHolder)?
    private let errorPlaceHolderHandler: ((Error) -> ErrorPlaceHolder)?
    
    init(
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
    
    init(source: Source, config: Config = .default) {
        self.init(provider: source.provider, config: config)
    }
}

extension RemoteImage: View {
    var body: some View {
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
