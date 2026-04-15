//
//  IDOWatchDialInfoModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

// MARK: - IDOWatchDialInfoModel
@objcMembers
public class IDOWatchDialInfoModel: NSObject, IDOBaseModel {
    /// Compression block size
    public var blockSize: Int
    /// Family name (maximum 10 bytes)
    public var familyName: String
    /// Color format
    public var format: Int
    /// Screen height (pixel size)
    public var height: Int
    /// Size in 100x increments
    public var sizex100: Int
    /// Screen width (pixel size)
    public var width: Int

    enum CodingKeys: String, CodingKey {
        case blockSize = "block_size"
        case familyName = "family_name"
        case format = "format"
        case height = "height"
        case sizex100 = "sizex100"
        case width = "width"
    }

    public init(blockSize: Int, familyName: String, format: Int, height: Int, sizex100: Int, width: Int) {
        self.blockSize = blockSize
        self.familyName = familyName
        self.format = format
        self.height = height
        self.sizex100 = sizex100
        self.width = width
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

