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
    
    var progress: AnyPublisher<Float, Never>? { return sessionDelegate.progress }
    var completion: AnyPublisher<NativeImage, Error>
    
    private let completionSubject = CurrentValueSubject<NativeImage, Error>(<#T##value: NativeImage##NativeImage#>)
    
    private let session: URLSession
    private let sessionDelegate = ImageDownloaderSessionDelegate()
    
    init(url: URL) {
        self.url = url
        session = URLSession(configuration: .ephemeral, delegate: sessionDelegate, delegateQueue: nil)
    }
    
    func download() {
        sessionDelegate.progress = { [weak self] (progress) in
            self?.progress(progress)
        }
        session.downloadTask(with: url, completionHandler: { (location, _, error) in
            if let error = error {
                self.failure(error)
                return
            }
            guard
                let location = location,
                let image = NativeImage(contentsOfFile: location.path)
                else {
                    self.failure(Errors.unknown)
                    return
                }
            self.success(image)
        }).resume()
    }
}


