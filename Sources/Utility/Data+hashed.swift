//
//  Data+hashed.swift
//  Macduff
//
//  Created by Koji Murata on 2019/09/06.
//

import Foundation
import CryptoKit

extension Data {
    var hashed: String {
        return SHA256.hash(data: self).reduce("", { return $0 + String(format: "%02x", $1) })
    }
}
