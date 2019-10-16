//
//  Source.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation

public protocol Source {
    var provider: ImageProvider { get }
}

extension URL: Source {
    public var provider: ImageProvider { return RemoteURLImageProvider(url: self) }
}
