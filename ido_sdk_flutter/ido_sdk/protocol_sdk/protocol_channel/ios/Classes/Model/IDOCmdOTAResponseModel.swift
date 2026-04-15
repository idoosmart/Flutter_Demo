//
//  IDOCmdOTAResponseModel.swift
//  protocol_channel
//
//  Created by hc on 2024/1/8.
//

import Foundation


// MARK: - IDOCmdOTAResponseModel
@objcMembers
public class IDOCmdOTAResponseModel: NSObject, IDOBaseModel {

    /// 0: 进入OTA成功
    /// 1: 失败：电量过低
    /// 2: 失败：设备不支持
    /// 3: 失败：参数不正确
    /// 
    /// 0: Enter OTA successfully
    /// 1: Failure: Battery is too low
    /// 2: Failure: Device not supported
    /// 3: Failure: Incorrect parameters
    public var errFlag: Int

    public init(errFlag: Int) {
        self.errFlag = errFlag
    }
    
    enum CodingKeys: String, CodingKey {
        case errFlag = "err_flag"
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
