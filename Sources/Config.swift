//
//  Config.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/03.
//

import SwiftUI

public struct Config {
    public static var `default` = Config()
    
    public let transition: AnyTransition
    public let fetchTrigger: FetchTrigger
    public let cache: Cache
    public let cacheTTL: TimeInterval
    
    public init(
        transition: AnyTransition = .opacity,
        fetchTrigger: FetchTrigger = .appear,
        cache: Cache = MemoryCache(),
        cacheTTL: TimeInterval = 60 * 60 * 24 * 30
    ) {
        self.transition = transition
        self.fetchTrigger = fetchTrigger
        self.cache = cache
        self.cacheTTL = cacheTTL
    }
    
    public enum FetchTrigger {
        case initialize
        case appear
    }
}
