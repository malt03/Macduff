//
//  RemoteImage.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/02.
//

import SwiftUI

public struct RemoteImage<ImageView: View, LoadingPlaceHolder: View, ErrorPlaceHolder: View> {
    private let content: RemoteImageContent<ImageView, LoadingPlaceHolder, ErrorPlaceHolder>

    init(
        with provider: ImageProvider?,
        imageView: @escaping (NativeImage) -> ImageView,
        loadingPlaceHolder: ((Float) -> LoadingPlaceHolder)?,
        errorPlaceHolder: ((Error) -> ErrorPlaceHolder)?,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        content = RemoteImageContent(
            with: provider,
            imageView: imageView,
            loadingPlaceHolder: loadingPlaceHolder,
            errorPlaceHolder: errorPlaceHolder,
            config: config,
            completion: completion
        )
    }
    
    init(
        with source: Source?,
        imageView: @escaping (NativeImage) -> ImageView,
        loadingPlaceHolder: ((Float) -> LoadingPlaceHolder)?,
        errorPlaceHolder: ((Error) -> ErrorPlaceHolder)?,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        self.init(
            with: source?.provider,
            imageView: imageView,
            loadingPlaceHolder: loadingPlaceHolder,
            errorPlaceHolder: errorPlaceHolder,
            config: config,
            completion: completion
        )
    }
}

extension RemoteImage: View {
    // When using RemoteImageContent directly, transitions did not work.
    public var body: some View {
        ZStack { content }
    }
}
