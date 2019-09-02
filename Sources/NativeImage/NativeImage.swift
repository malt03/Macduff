//
//  NativeImage.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation

#if os(macOS)
import AppKit
public typealias NativeImage = NSImage
#else
import UIKit
public typealias NativeImage = UIImage
#endif
