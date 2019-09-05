//
//  Config.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/03.
//

import SwiftUI

public struct Config {
    public static var `default` = Config(
        transition: .opacity,
        fetchTrigger: .appear,
        cache: MemoryCache(),
        cacheTTL: 60 * 60 * 24 * 30,
        imageProcessor: nil
    )
    
    public let transition: AnyTransition
    public let fetchTrigger: FetchTrigger
    public let cache: Cache
    public let cacheTTL: TimeInterval
    public let imageProcessor: ImageProcessor?
    
    public init(
        transition: AnyTransition = Config.default.transition,
        fetchTrigger: FetchTrigger = Config.default.fetchTrigger,
        cache: Cache = Config.default.cache,
        cacheTTL: TimeInterval = Config.default.cacheTTL,
        imageProcessor: ImageProcessor? = Config.default.imageProcessor
    ) {
        self.transition = transition
        self.fetchTrigger = fetchTrigger
        self.cache = cache
        self.cacheTTL = cacheTTL
        self.imageProcessor = imageProcessor
    }
    
    public enum FetchTrigger {
        case initialize
        case appear
    }
}
