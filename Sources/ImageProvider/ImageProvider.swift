//
//  ImageProvider.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/02.
//

import Foundation
import Combine

protocol ImageProvider {
    var progress: AnyPublisher<Float, Never>? { get }
    var completion: AnyPublisher<NativeImage, Error> { get }
}
