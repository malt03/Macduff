//
//  Config.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation

struct Config {
    static var `default` = Config()
    
    let cache: Cache = DiskCache()
}
