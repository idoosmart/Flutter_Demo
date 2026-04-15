//
//  MeasureDelegateImpl.swift
//  protocol_channel
//
//  Created by hc on 2026/3/19.
//

import Foundation

class MeasureDelegateImpl: MeasureDelegate {
    static let shared = MeasureDelegateImpl()
    private init() {}
    
    var callbackProcessMeasureData: ((MeasureResult) -> Void)?
    
    func listenMeasureResult(result: MeasureResult) throws {
        callbackProcessMeasureData?(result)
    }
}
