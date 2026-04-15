//
//  IDOWatchFaceModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

// MARK: - IDOWatchFaceModel
@objcMembers
public class IDOWatchFaceModel: NSObject, IDOBaseModel {
    /// Error code, 0 for success, non-zero for error
    public var errCode: Int
    /// Operation:<br />0 - Query the currently used watch face<br />1 - Set watch face<br />2 - Delete watch face<br />3 - Dynamic request space to set the corresponding space size
    public var operate: Int
    /// Watch face name, maximum 29 bytes
    public var fileName: String?
    /// Number of files<br /><br />Requires the firmware to enable the function table `v3WatchDailSetAddSize`
    /// If operate!=3, this data is the same as before, which is 1 and is saved as before
    /// If operate=3: dynamic request space to set the corresponding space size, this corresponds to a deleted file name column
    /// If `v3WatchDailSetAddSize` is not enabled, this field defaults to 1
    public var fileCount: Int
    
    enum CodingKeys: String, CodingKey {
        case errCode = "err_code"
        case operate = "operate"
        case fileName = "file_name"
        case fileCount = "file_count"
    }
    
    public init(errCode: Int, operate: Int, fileName: String?, fileCount: Int = 0) {
        self.errCode = errCode
        self.operate = operate
        self.fileName = fileName
        self.fileCount = fileCount
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errCode = try container.decode(Int.self, forKey: .errCode)
        operate = try container.decode(Int.self, forKey: .operate)
        fileCount = try container.decode(Int.self, forKey: .fileCount)
        
        if let value = try container.decodeIfPresent(Array<String>.self, forKey: .fileName) {
            fileName = value.first
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(errCode, forKey: .errCode)
        try container.encode(operate, forKey: .operate)
        try container.encode(fileCount, forKey: .fileCount)
        try container.encode([fileName ?? ""], forKey: .fileName)
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOWatchFaceParamModel
@objcMembers
public class IDOWatchFaceParamModel: NSObject, IDOBaseModel {
    /// Operation:
    /// ```
    /// 0 - Query the currently used watch face
    /// 1 - Set watch face
    /// 2 - Delete watch face
    /// 3 - Dynamic request space to set the corresponding space size
    /// ```
    public var operate: Int
    /// Watch face name, maximum 29 bytes
    public var fileName: String
    /// Uncompressed file length
    /// After the firmware opens the function table `v3WatchDailSetAddSize`, the app needs to send this field
    /// Before the watch face is transmitted, the firmware needs to allocate corresponding space to save it, and the uncompressed file length needs to be transmitted
    public var watchFileSize: Int
    
    enum CodingKeys: String, CodingKey {
        case operate = "operate"
        case fileName = "file_name"
        case watchFileSize = "watch_file_size"
    }
    
    public init(operate: Int, fileName: String, watchFileSize: Int) {
        self.operate = operate
        self.fileName = fileName
        self.watchFileSize = watchFileSize
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
