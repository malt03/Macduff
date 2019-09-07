//
//  FixedDateProvider.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/07.
//

import XCTest
@testable import Macduff

struct FixedDateProvider: DateProvider {
    let date: Date
    func getDate() -> Date { date }
}

extension XCTestCase {
    func fixDate(_ date: Date) {
        DateGenerator.setProvider(FixedDateProvider(date: date))
    }
    
    func unfixDate() {
        DateGenerator.setDefaultProvider()
    }
}
