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
        for i in 0..<10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(i) / 5, execute: {
                progress(Float(i) / 10)
            })
        }
//        ImageDownloader(url: url).download(progress: progress, success: success, failure: failure)
    }
}
