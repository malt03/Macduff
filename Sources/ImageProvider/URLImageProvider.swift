//
//  URLImageProvider.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation
import Combine

struct RemoteURLImageProvider: ImageProvider {
    var progress: AnyPublisher<Float, Never>?
    var completion: AnyPublisher<NativeImage, Error>
    
    let url: URL
    
    

    func provide(progress: @escaping (Float) -> Void, success: @escaping (NativeImage) -> Void, failure: @escaping (Error) -> Void) {
        ImageDownloader(url: url, progress: progress, success: success, failure: failure).download()
    }
}
