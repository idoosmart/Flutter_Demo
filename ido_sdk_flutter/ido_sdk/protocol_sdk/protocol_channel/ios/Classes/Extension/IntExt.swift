//
//  IntExt.swift
//  protocol_channel
//
//  Created by hc on 2023/11/7.
//

import Foundation

extension Int {
    
    /// Bit operation
    func toBits() -> [Int] {
        var bits: [Int] = Array(repeating: 0, count: 8)
        for i in 0..<8 {
            let mask = 1 << i
            bits[i] = (self & mask) >> i
        }
        //bits.reverse()
        return bits
    }
}

