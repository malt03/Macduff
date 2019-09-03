//
//  NativeSupport.swift
//  RemoteImage-iOS
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
    func publisherForMemoryWarning() -> NotificationCenter.Publisher? {
        return nil
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

extension NotificationCenter {
    func publisherForMemoryWarning() -> NotificationCenter.Publisher? {
        publisher(for: UIApplication.didReceiveMemoryWarningNotification)
    }
}

#endif
