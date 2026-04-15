import Foundation

/// 设置宠物信息入参
@objcMembers
public class IDOPetInfoParamModel: NSObject, IDOBaseModel {
    /// 0x00无效 0x01猫 0x02狗
    public var petType: Int

    /// 体重x100，单位kg
    public var weight: Int

    /// 性别 0x0 公 0x1 母
    public var gender: Int

    /// 生日年
    public var year: Int

    /// 生日月
    public var month: Int

    /// 生日日
    public var day: Int

    enum CodingKeys: String, CodingKey {
        case petType = "pet_type"
        case weight
        case gender
        case year
        case month
        case day
    }

    public init(petType: Int, weight: Int, gender: Int, year: Int, month: Int, day: Int) {
        self.petType = petType
        self.weight = weight
        self.gender = gender
        self.year = year
        self.month = month
        self.day = day
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}

