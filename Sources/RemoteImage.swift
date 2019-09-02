//
//  RemoteImage.swift
//  RemoteImage
//
//  Created by Koji Murata on 2019/09/02.
//

import SwiftUI

struct RemoteImage<PlaceHolderView: View> {
    @ObservedObject private var imageFetcher: ImageFetcher
    
    private let completionHandler: ((Status) -> Void)?
    private let placeHolderHandler: ((Float) -> PlaceHolderView)?
    
    init(
        provider: ImageProvider,
        placeHolder: ((Float) -> PlaceHolderView)? = nil,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        imageFetcher = ImageFetcher(provider: provider, config: config)
        placeHolderHandler = placeHolder
        completionHandler = completion
    }
    
    init(source: Source, config: Config = .default) {
        self.init(provider: source.provider, config: config)
    }
}

extension RemoteImage: View {
    var body: some View {
        if let image = imageFetcher.image {
            return ZStack<TupleView<(Image?, PlaceHolderView?)>> {
                Image(nativeImage: image)
                nil
            }
        } else {
            return ZStack<TupleView<(Image?, PlaceHolderView?)>> {
                nil
                placeHolderHandler?(imageFetcher.progress)
            }
        }
    }
    
    func onAppear(perform action: (() -> Void)? = nil) -> some View
    {
        imageFetcher.fetch(completion: completionHandler)
        action?()
        return self
    }
}
