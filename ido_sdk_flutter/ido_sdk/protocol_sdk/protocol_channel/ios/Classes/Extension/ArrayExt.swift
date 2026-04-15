//
//  ArrayExt.swift
//  protocol_channel
//
//  Created by hc on 2023/11/7.
//

import Foundation

extension Array where Element == Bool? {
    
    /// Bit operation
    func toInt() -> Int {
        let bits = map { ($0 != nil && $0 == true) ? 1 : 0 }
        let intValue = bits.reduce(0) { $0 << 1 + $1 }
        return intValue
    }
}
