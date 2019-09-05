//
//  RemoteImage+Initializers.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/05.
//

import SwiftUI

extension RemoteImage {
    public init(
        with provider: ImageProvider,
        imageView: @escaping (NativeImage) -> ImageView,
        loadingPlaceHolder: @escaping (Float) -> LoadingPlaceHolder,
        errorPlaceHolder: @escaping (Error) -> ErrorPlaceHolder,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        self.init(
            with: provider,
            imageView: imageView,
            loadingPlaceHolder: Optional(loadingPlaceHolder),
            errorPlaceHolder: Optional(errorPlaceHolder),
            config: config,
            completion: completion
        )
    }
    
    public init(
        with source: Source,
        imageView: @escaping (NativeImage) -> ImageView,
        loadingPlaceHolder: @escaping (Float) -> LoadingPlaceHolder,
        errorPlaceHolder: @escaping (Error) -> ErrorPlaceHolder,
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
}

extension RemoteImage where ImageView == Image {
    public init(
        with provider: ImageProvider,
        loadingPlaceHolder: @escaping (Float) -> LoadingPlaceHolder,
        errorPlaceHolder: @escaping (Error) -> ErrorPlaceHolder,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        self.init(
            with: provider,
            imageView: { Image(nativeImage: $0).resizable() },
            loadingPlaceHolder: loadingPlaceHolder,
            errorPlaceHolder: errorPlaceHolder,
            config: config,
            completion: completion
        )
    }
    
    public init(
        with source: Source,
        loadingPlaceHolder: @escaping (Float) -> LoadingPlaceHolder,
        errorPlaceHolder: @escaping (Error) -> ErrorPlaceHolder,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        self.init(
            with: source.provider,
            loadingPlaceHolder: loadingPlaceHolder,
            errorPlaceHolder: errorPlaceHolder,
            config: config,
            completion: completion
        )
    }
}

extension RemoteImage where ImageView == Image, LoadingPlaceHolder == ErrorPlaceHolder {
    public init(
        with provider: ImageProvider,
        placeHolder: @escaping () -> LoadingPlaceHolder,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        self.init(
            with: provider,
            loadingPlaceHolder: { _ in placeHolder() },
            errorPlaceHolder: { _ in placeHolder() },
            config: config,
            completion: completion
        )
    }
    
    public init(
        with source: Source,
        placeHolder: @escaping () -> LoadingPlaceHolder,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        self.init(
            with: source.provider,
            placeHolder: placeHolder,
            config: config,
            completion: completion
        )
    }
}

extension RemoteImage where ImageView == Image, LoadingPlaceHolder == EmptyView, ErrorPlaceHolder == EmptyView {
    public init(
        with provider: ImageProvider,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        self.init(
            with: provider,
            imageView: { Image(nativeImage: $0).resizable() },
            loadingPlaceHolder: nil,
            errorPlaceHolder: nil,
            config: config,
            completion: completion
        )
    }
    
    public init(
        with source: Source,
        config: Config = .default,
        completion: ((Status) -> Void)? = nil
    ) {
        self.init(
            with: source.provider,
            config: config,
            completion: completion
        )
    }
}
