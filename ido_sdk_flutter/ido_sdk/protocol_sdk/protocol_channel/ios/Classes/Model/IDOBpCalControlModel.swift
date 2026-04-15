//
//  IDOBpCalControlModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

// MARK: - IDOBpCalControlModel
@objcMembers
public class IDOBpCalControlModel: NSObject, IDOBaseModel {
    /// Error code: 0 for success, non-zero for failure
    public var errorCode: Int
    /// Operation
    /// ```
    /// 0: Invalid
    /// 1: Start blood pressure calibration
    /// 2: Stop blood pressure calibration
    /// 3: Get feature vector
    /// ```
    public var operate: Int
    /// Number of high blood pressure PPG feature vectors
    /// Valid when operate=3
    public var sbpPpgFeatureNum: Int
    /// Number of low blood pressure PPG feature vectors
    /// Valid when operate=3
    public var dbpPpgFeatureNum: Int
    /// Array of high blood pressure PPG feature vectors
    /// Valid when operate=3
    public var sbpPpgFeatureItems: [Int]
    /// Array of low blood pressure PPG feature vectors
    /// Valid when operate=3
    public var dbpPpgFeatureItems: [Int]

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case operate = "operate"
        case sbpPpgFeatureNum = "sbp_ppg_feature_num"
        case dbpPpgFeatureNum = "dbp_ppg_feature_num"
        case sbpPpgFeatureItems = "sbp_ppg_feature_items"
        case dbpPpgFeatureItems = "dbp_ppg_feature_items"
    }

    public init(errorCode: Int, operate: Int, sbpPpgFeatureNum: Int, dbpPpgFeatureNum: Int, sbpPpgFeatureItems: [Int], dbpPpgFeatureItems: [Int]) {
        self.errorCode = errorCode
        self.operate = operate
        self.sbpPpgFeatureNum = sbpPpgFeatureNum
        self.dbpPpgFeatureNum = dbpPpgFeatureNum
        self.sbpPpgFeatureItems = sbpPpgFeatureItems
        self.dbpPpgFeatureItems = dbpPpgFeatureItems
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
