//
//  URLImageProvider.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation
import Combine

struct RemoteURLImageProvider: ImageProvider {
    var cacheKey: String { url.absoluteString }
    
    let url: URL
        
    func run(progress: @escaping (Float) -> Void, success: @escaping (ProvidingImage) -> Void, failure: @escaping (Error) -> Void) {
        ImageDownloader(url: url).download(progress: progress, success: success, failure: failure)
    }
}
