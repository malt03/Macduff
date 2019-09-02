//
//  ImageDownloaderSessionDelegate.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation
import Combine

final class ImageDownloaderSessionDelegate: NSObject, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {}
    
    var progress: AnyPublisher<Float, Never> { return progressSubject }
    private let progressSubject = CurrentValueSubject<Float, Never>(0)
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progressSubject.send(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
    }
}
