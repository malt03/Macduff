//
//  Source.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation

protocol Source {
    var provider: ImageProvider { get }
}

extension URL: Source {
    var provider: ImageProvider { return RemoteURLImageProvider(url: self) }
}
