//
//  NativeSupport.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation
import SwiftUI

#if os(iOS) || os(tvOS)

extension NotificationCenter {
    func publisherForMemoryWarning() -> NotificationCenter.Publisher? {
        publisher(for: UIApplication.didReceiveMemoryWarningNotification)
    }
    
    func didEnterBackground() -> NotificationCenter.Publisher? {
        publisher(for: UIApplication.didEnterBackgroundNotification)
    }
}

#elseif os(macOS)

extension NotificationCenter {
    func publisherForMemoryWarning() -> NotificationCenter.Publisher? { nil }
    func didEnterBackground() -> NotificationCenter.Publisher? {
        publisher(for: NSApplication.didResignActiveNotification)
    }
}

#else

extension NotificationCenter {
    func publisherForMemoryWarning() -> NotificationCenter.Publisher? { nil }
    func didEnterBackground() -> NotificationCenter.Publisher? { nil }
}

#endif

#if os(iOS) || os(tvOS)

func backgroundTask(expirationHandler: @escaping () -> Void, task: (@escaping () -> Void) -> Void) {
    var identifier = UIApplication.shared.beginBackgroundTask(expirationHandler: expirationHandler)
    task {
        if identifier == .invalid { return }
        UIApplication.shared.endBackgroundTask(identifier)
        identifier = .invalid
    }
}

#else

func backgroundTask(expirationHandler: @escaping () -> Void, task: (@escaping () -> Void) -> Void) {
    task { }
}

#endif

#if os(macOS)

import AppKit
public typealias NativeImage = NSImage

extension Image {
    init(nativeImage: NativeImage) {
        self.init(nsImage: nativeImage)
    }
}

extension NSImage {
    func pngData() -> Data? {
        guard let cgRef = cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let newRep = NSBitmapImageRep(cgImage: cgRef)
        newRep.size = size
        return newRep.representation(using: .png, properties: [:])
    }
    
    convenience init(cgImage: CGImage) {
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        self.init(cgImage: cgImage, size: size)
    }
}

extension CIImage {
    convenience init?(image: NSImage) {
        guard let cgRef = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        self.init(cgImage: cgRef)
    }
}

#else

import UIKit
public typealias NativeImage = UIImage

extension Image {
    init(nativeImage: NativeImage) {
        self.init(uiImage: nativeImage)
    }
}

#endif
