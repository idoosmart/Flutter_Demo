//
//  IDOBtNoticeModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Query BT pairing switch, connection, A2DP connection, HFP connection status (Only Supported on devices with BT Bluetooth) event number
@objcMembers
public class IDOBtNoticeModel: NSObject, IDOBaseModel {
    /// 1: BT connection status on
    /// 0: BT connection status off
    /// -1: Invalid
    public var btConnectStates: Int
    /// 1: BT pairing status on
    /// 0: BT pairing status off
    /// -1: Invalid
    public var btPairStates: Int
    /// 1: A2DP connection status on
    /// 0: A2DP connection status off
    /// -1: Invalid
    public var a2dpConnectStates: Int
    /// 1: HFP connection status on
    /// 0: HFP connection status off
    /// -1: Invalid
    public var hfpConnectStates: Int

    enum CodingKeys: String, CodingKey {
        case btConnectStates = "bt_connect_states"
        case btPairStates = "bt_pair_states"
        case a2dpConnectStates = "a2dp_connect_states"
        case hfpConnectStates = "hfp_connect_states"
    }

    public init(btConnectStates: Int, btPairStates: Int, a2dpConnectStates: Int, hfpConnectStates: Int) {
        self.btConnectStates = btConnectStates
        self.btPairStates = btPairStates
        self.a2dpConnectStates = a2dpConnectStates
        self.hfpConnectStates = hfpConnectStates
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
