//
//  Config.swift
//  RemoteImage-iOS
//
//  Created by Koji Murata on 2019/09/03.
//

import Foundation

public struct Config {
    public static var `default` = Config()
    
    public let cache: Cache
    public let cacheTTL: TimeInterval
    
    public init(cache: Cache = MemoryCache(), cacheTTL: TimeInterval = 60 * 60 * 24 * 30) {
        self.cache = cache
        self.cacheTTL = cacheTTL
    }
}
