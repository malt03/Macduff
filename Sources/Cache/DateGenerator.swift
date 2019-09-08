//
//  DateGenerator.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/07.
//

import Foundation

public struct DateGenerator {
    private static var provider: DateProvider = DefaultDateProvider()
    
    static func now() -> Date {
        return provider.getDate()
    }
    
    public static func setProvider(_ provider: DateProvider) {
        self.provider = provider
    }
    
    public static func setDefaultProvider() {
        provider = DefaultDateProvider()
    }
}

public protocol DateProvider {
    func getDate() -> Date
}

struct DefaultDateProvider: DateProvider {
    func getDate() -> Date { return Date() }
}
