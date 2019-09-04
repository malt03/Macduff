//
//  ImageDownloader.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation
import Combine

final class ImageDownloader {
    let url: URL
    
    private let progressHandler: (Float) -> Void
    private let successHandler: (ProvidingImage) -> Void
    private let failureHandler: (Error) -> Void
    
    init(url: URL, progress: @escaping (Float) -> Void, success: @escaping (ProvidingImage) -> Void, failure: @escaping (Error) -> Void) {
        self.url = url
        progressHandler = progress
        successHandler = success
        failureHandler = failure
    }
    
    func download() {
        ImageDownloaderSession.shared.run(downloader: self)
    }
    
    func progress(progress: Float) {
        progressHandler(progress)
    }

    func success(image: ProvidingImage) {
        successHandler(image)
    }
    
    func failure(error: Error) {
        failureHandler(error)
    }
}
