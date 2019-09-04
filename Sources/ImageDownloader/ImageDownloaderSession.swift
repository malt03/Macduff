//
//  ImageDownloaderSession.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/05.
//

import Foundation

final class ImageDownloaderSession {
    enum Errors: Error {
        case unknown
    }
    
    static let shared = ImageDownloaderSession()
    
    private let session: URLSession
    private let delegate: Delegate
    
    init() {
        delegate = Delegate()
        session = URLSession(configuration: .ephemeral, delegate: delegate, delegateQueue: .main)
    }
    
    func run(downloader: ImageDownloader) {
        let task = session.downloadTask(with: downloader.url)
        Dispatcher.shared.add(downloader: downloader, for: task)
        task.resume()
    }
    
    private final class Dispatcher {
        static let shared = Dispatcher()
        private init() {}
        
        private var downloaders = [URLSessionTask: ImageDownloader]()
        
        let lock = NSLock()
        
        func add(downloader: ImageDownloader, for task: URLSessionTask) {
            lock.lock()
            defer { lock.unlock() }

            downloaders[task] = downloader
        }
        
        fileprivate func progress(task: URLSessionTask, progress: Float) {
            lock.lock()
            defer { lock.unlock() }

            downloaders[task]?.progress(progress: progress)
        }

        fileprivate func success(task: URLSessionTask, image: ProvidingImage) {
            lock.lock()
            defer { lock.unlock() }

            downloaders[task]?.success(image: image)
            downloaders[task] = nil
        }
        
        fileprivate func failure(task: URLSessionTask, error: Error) {
            lock.lock()
            defer { lock.unlock() }

            downloaders[task]?.failure(error: error)
            downloaders[task] = nil
        }
    }

    private final class Delegate: NSObject, URLSessionDownloadDelegate {
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            guard
                let data = try? Data(contentsOf: location),
                let image = NativeImage(data: data)
                else {
                    Dispatcher.shared.failure(task: downloadTask, error: Errors.unknown)
                    return
            }
            Dispatcher.shared.success(task: downloadTask, image: ProvidingImage(image: image, originalData: data))
        }
        
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            if totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown { return }
            Dispatcher.shared.progress(task: downloadTask, progress: Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
        }
        
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if let error = error { Dispatcher.shared.failure(task: task, error: error) }
        }
    }
}
