//
//  ImageDownloader.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation
import Combine

final class ImageDownloader {
    enum Errors: Error {
        case unknown
    }
    
    private let url: URL
    
    private let session: URLSession
    private let sessionDelegate = ImageDownloaderSessionDelegate()
    
    init(url: URL) {
        self.url = url
        session = URLSession(configuration: .ephemeral, delegate: sessionDelegate, delegateQueue: nil)
    }
    
    func download(progress: @escaping (Float) -> Void, success: @escaping (ProvidingImage) -> Void, failure: @escaping (Error) -> Void) {
        sessionDelegate.progressHandler = progress
        session.downloadTask(with: url, completionHandler: { (location, _, error) in
            defer { self.session.finishTasksAndInvalidate() }

            self.sessionDelegate.progressHandler = nil
            if let error = error {
                failure(error)
                return
            }
            guard
                let location = location,
                let data = try? Data(contentsOf: location),
                let image = NativeImage(data: data)
                else {
                    failure(Errors.unknown)
                    return
                }
            success(ProvidingImage(image: image, originalData: data))
        }).resume()
    }
}


