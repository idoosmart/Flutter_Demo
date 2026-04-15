import Foundation

/// 设置宠物信息返回
@objcMembers
public class IDOPetInfoReplyModel: NSObject, IDOBaseModel {
    /// 0：成功；其他：失败
    public var retCode: Int

    enum CodingKeys: String, CodingKey {
        case retCode = "ret_code"
    }

    public init(retCode: Int) {
        self.retCode = retCode
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}

