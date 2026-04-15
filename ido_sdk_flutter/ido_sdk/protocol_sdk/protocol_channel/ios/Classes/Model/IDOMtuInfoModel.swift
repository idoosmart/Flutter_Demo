//
//  IDOMtuInfoModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get MTU Information event number
@objcMembers
public class IDOMtuInfoModel: NSObject, IDOBaseModel {
    /// 0: Data is valid
    /// 1: Data is invalid, wait a while and try again. In case of invalid data, MTU is 20.
    public var status: Int
    /// MTU for app receiving data
    public var rxMtu: Int
    /// MTU for app sending data
    public var txMtu: Int
    /// Physical layer speed
    /// 0: Invalid
    /// 1000: 1M
    /// 2000: 2M
    /// 512: 512K
    public var phySpeed: Int
    /// DLE length
    /// 0: Not supported
    public var dleLength: Int

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case rxMtu = "rx_mtu"
        case txMtu = "tx_mtu"
        case phySpeed = "phy_speed"
        case dleLength = "dle_length"
    }

    public init(status: Int, rxMtu: Int, txMtu: Int, phySpeed: Int, dleLength: Int) {
        self.status = status
        self.rxMtu = rxMtu
        self.txMtu = txMtu
        self.phySpeed = phySpeed
        self.dleLength = dleLength
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
