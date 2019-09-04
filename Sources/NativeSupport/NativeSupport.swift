//
//  NativeSupport.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation
import SwiftUI

#if os(macOS)

import AppKit
public typealias NativeImage = NSImage

extension Image {
    init(nativeImage: NativeImage) {
        self.init(nsImage: nativeImage)
    }
}

extension NotificationCenter {
    func publisherForMemoryWarning() -> NotificationCenter.Publisher? { nil }
    func didEnterBackground() -> NotificationCenter.Publisher {
        publisher(for: NSApplication.didResignActiveNotification)
    }
}

func backgroundTask(expirationHandler: @escaping () -> Void, task: (@escaping () -> Void) -> Void) {
    task { _ in }
}

#else

import UIKit
public typealias NativeImage = UIImage

extension Image {
    init(nativeImage: NativeImage) {
        self.init(uiImage: nativeImage)
    }
}

extension NotificationCenter {
    func publisherForMemoryWarning() -> NotificationCenter.Publisher? {
        publisher(for: UIApplication.didReceiveMemoryWarningNotification)
    }
    
    func didEnterBackground() -> NotificationCenter.Publisher {
        publisher(for: UIApplication.didEnterBackgroundNotification)
    }
}

func backgroundTask(expirationHandler: @escaping () -> Void, task: (@escaping () -> Void) -> Void) {
    var identifier = UIApplication.shared.beginBackgroundTask(expirationHandler: expirationHandler)
    task {
        if identifier == .invalid { return }
        UIApplication.shared.endBackgroundTask(identifier)
        identifier = .invalid
    }
}

#endif
