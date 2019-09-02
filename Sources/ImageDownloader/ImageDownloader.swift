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
    
    func download(progress: @escaping (Float) -> Void, success: @escaping (NativeImage) -> Void, failure: @escaping (Error) -> Void) {
        sessionDelegate.progressHandler = progress
        session.downloadTask(with: url, completionHandler: { (location, _, error) in
            self.sessionDelegate.progressHandler = nil
            if let error = error {
                failure(error)
                return
            }
            guard
                let location = location,
                let image = NativeImage(contentsOfFile: location.path)
                else {
                    failure(Errors.unknown)
                    return
                }
            success(image)
        }).resume()
    }
}


