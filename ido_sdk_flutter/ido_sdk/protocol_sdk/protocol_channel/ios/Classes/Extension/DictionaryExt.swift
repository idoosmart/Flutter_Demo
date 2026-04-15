//
//  DictionaryExt.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation

extension Dictionary where Key == String, Value: Any {
    func toJsonString() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Error converting dictionary to JSON string: \(error.localizedDescription)")
            return nil
        }
    }
}
