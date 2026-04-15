//
//  IDOSportModeSortParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

// MARK: - IDOSportModeSortParamModel
@objcMembers
public class IDOSportParamModel: NSObject, IDOBaseModel {
    /// 运动类型详情个数，最大30个
    private let num: Int
    /// 运动类型排序详情
    public var items: [IDOSportModeSortParamModel]
    
    enum CodingKeys: String, CodingKey {
        case num
        case items = "item"
    }
    
    public init(items: [IDOSportModeSortParamModel]) {
        self.items = items
        self.num = items.count
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOSportModeSortParamModel
@objcMembers
public class IDOSportModeSortParamModel: NSObject, IDOBaseModel {
    /// Sorting index (starting from 1, 0 is invalid)
    public var index: Int
    public var type: IDOSportType
    
    enum CodingKeys: String, CodingKey {
        case index
        case type
    }
    
    public init(index: Int, type: IDOSportType) {
        self.index = index
        self.type = type
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOSportSortParamModel
@objcMembers
public class IDOSportSortParamModel: NSObject, IDOBaseModel {
    private let version: Int
    /// Operation <br />0: Invalid 1: Query 2: Set
    public var operate: Int
    /// Type of sport
    public var sportType: IDOSportType
    /// Current position of displayed added sports
    public var nowUserLocation: Int
    private let allNum: Int
    public var items: [Int]
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case operate = "operate"
        case sportType = "sport_type"
        case nowUserLocation = "now_user_location"
        case allNum = "all_num"
        case items = "items"
    }
    
    public init(operate: Int, sportType: IDOSportType, nowUserLocation: Int, items: [Int]) {
        self.version = 0
        self.operate = operate
        self.sportType = sportType
        self.nowUserLocation = nowUserLocation
        self.allNum = items.count
        self.items = items
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOSport100SortParamModel
@objcMembers
public class IDOSport100SortParamModel: NSObject, IDOBaseModel {
    private let version: Int
    /// Operation <br />0: Invalid 1: Query 2: Set
    public var operate: Int
    /// Current position of displayed added sports
    public var nowUserLocation: Int
    private let allNum: Int
    public var items: [Int]
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case operate = "operate"
        case nowUserLocation = "now_user_location"
        case allNum = "all_num"
        case items = "items_set"
    }
    
    public init(operate: Int, nowUserLocation: Int, items: [Int]) {
        self.version = 0
        self.operate = operate
        self.nowUserLocation = nowUserLocation
        self.allNum = items.count
        self.items = items
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOSport100SortModel
@objcMembers
public class IDOSport100SortModel: NSObject, IDOBaseModel {
    private let version: Int
    /// 0: Success, Non-zero: Failure
    public var errCode: Int
    /// Operation <br />0: Invalid 1: Query 2: Set
    public var operate: Int
    /// Minimum number of items to be displayed, at least 1
    public var minShowNum: Int
    /// Maximum number of items to be displayed, maximum 20
    public var maxShowNum: Int
    /// Current position of displayed added sports, app displays based on this position, with the devices added before corresponding to those positions, and those added later to the positions after this position. Only valid for queries
    public var nowUserLocation: Int
    private var allNum: Int? = 0
    public var items: [IDOSport100SortItem]?
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case errCode = "err_code"
        case operate = "operate"
        case minShowNum = "min_show_num"
        case maxShowNum = "max_show_num"
        case nowUserLocation = "now_user_location"
        case allNum = "all_num"
        case items = "items"
    }
    
    public init(errCode: Int, operate: Int, minShowNum: Int, maxShowNum: Int, nowUserLocation: Int, items: [IDOSport100SortItem]) {
        self.version = 0
        self.errCode = errCode
        self.operate = operate
        self.minShowNum = minShowNum
        self.maxShowNum = maxShowNum
        self.nowUserLocation = nowUserLocation
        self.allNum = items.count
        self.items = items
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOSport100SortItem
@objcMembers
public class IDOSport100SortItem: NSObject, Codable {
    /// Type of sport
    public var type: IDOSportType
    /// 0: None downloaded for all<br />Bit0: Small icon downloaded<br />Bit1: Big icon downloaded<br />Bit2: Medium icon downloaded<br />Bit3: Smallest icon downloaded
    public var flag: Int
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case flag = "flag"
    }
    
    // ------------------------------------------------------------------
    // 重点增强：实现自定义 Decodable 的初始化方法 init(from decoder:)
    // ------------------------------------------------------------------
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.flag = try container.decode(Int.self, forKey: .flag)
        
        // 2. 安全解码 type
        do {
            // 尝试正常解码 IDOSportType
            self.type = try container.decode(IDOSportType.self, forKey: .type)
        } catch {
            #if DEBUG
            // 解码失败（数值不在枚举范围内）
            print("⚠️ [Decoding Error]: Failed to decode IDOSportType for key 'type'. Falling back to .sportTypeNull (0). Error: \(error)")
            #endif
            // 赋予一个安全的默认值，例如 sportTypeNull
            self.type = .sportTypeUnkonw
        }
        
        super.init()
    }
    
    // ------------------------------------------------------------------
    // 由于手动实现了 Decodable，还需要确保手动实现 Encodable，或者依赖默认实现
    // 由于此模型使用 NSObject，如果所有属性都可被默认编码器访问，可以省略 encode(to:)
    // 但为了完整性，最好显式实现 Encodable
    // ------------------------------------------------------------------
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(flag, forKey: .flag)
        try container.encode(type, forKey: .type)
    }
    
    public init(type: IDOSportType, flag: Int) {
        self.type = type
        self.flag = flag
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOSportSortModel
@objcMembers
public class IDOSportSortModel: NSObject, IDOBaseModel {
    private let version: Int
    /// 0: Success, Non-zero: Failure
    public var errCode: Int
    /// Operation <br />0: Invalid 1: Query 2: Set
    public var operate: Int
    /// Type of sport
    public var sportType: IDOSportType
    /// Current position of displayed added sports, app displays based on this position, with the devices added before corresponding to those positions, and those added later to the positions after this position. Only valid for queries
    public var nowUserLocation: Int
    private let allNum: Int
    public var items: [Int]
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case errCode = "err_code"
        case operate = "operate"
        case sportType = "sport_type"
        case nowUserLocation = "now_user_location"
        case allNum = "all_num"
        case items = "items"
    }
    
    public init(operate: Int, errCode: Int, sportType: IDOSportType, nowUserLocation: Int, items: [Int]) {
        self.version = 0
        self.operate = operate
        self.sportType = sportType
        self.nowUserLocation = nowUserLocation
        self.allNum = items.count
        self.items = items
        self.errCode = errCode
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOSportType
@objc
public enum IDOSportType: Int, Codable {
    
    /// 未知类型
    case sportTypeUnkonw = -1
    
    /// 无运动类型
    case sportTypeNull = 0
    
    /// 走路
    case sportTypeWalk = 1
    
    /// 跑步
    case sportTypeRun = 2
    
    /// 骑行
    case sportTypeCycling = 3
    
    /// 徒步
    case sportTypeOnFoot = 4
    
    /// 游泳
    case sportTypeSwim = 5
    
    /// 爬山
    case sportTypeClimb = 6
    
    /// 羽毛球
    case sportTypeBadminton = 7
    
    /// 其他
    case sportTypeOther = 8
    
    /// 健身
    case sportTypeFitness = 9
    
    /// 动感单车
    case sportTypeDynamic = 10
    
    /// 椭圆球
    case sportTypeEllipsoid = 11
    
    /// 跑步机
    case sportTypeTreadmill = 12
    
    /// 仰卧起坐
    case sportTypeSitUp = 13
    
    /// 俯卧撑
    case sportTypePushUp = 14
    
    /// 哑铃
    case sportTypeDumbbells = 15
    
    /// 举重
    case sportTypeLifting = 16
    
    /// 健身操
    case sportTypeAerobics = 17
    
    /// 瑜伽
    case sportTypeYoga = 18
    
    /// 跳绳
    case sportTypeRope = 19
    
    /// 乒乓球
    case sportTypePingPong = 20
    
    /// 篮球
    case sportTypeBasketball = 21
    
    /// 足球
    case sportTypeSoccer = 22
    
    /// 排球
    case sportTypeVolleyball = 23
    
    /// 网球
    case sportTypeTennisBall = 24
    
    /// 高尔夫球
    case sportTypeGolf = 25
    
    /// 棒球
    case sportTypeBaseball = 26
    
    /// 滑冰/滑雪
    case sportTypeSki = 27
    
    /// 轮滑
    case sportTypeRoller = 28
    
    /// 跳舞
    case sportTypeDancing = 29

    /// 笼式网球
    case sportTypeCageTennis = 30
    
    /// 滚轮训练机/室内划船
    case sportTypeRollerMachine = 31
    
    /// 普拉提
    case sportTypePilates = 32
    
    /// 交叉训练
    case sportTypeCrossTrain = 33
    
    /// 有氧运动
    case sportTypeCardio = 34
    
    /// 尊巴舞
    case sportTypeZumba = 35
    
    /// 广场舞
    case sportTypeSquareDance = 36
    
    /// 平板支撑
    case sportTypePlank = 37
    
    /// 健身房
    case sportTypeGym = 38
    
    /// 有氧健身操
    case sportTypeOxAerobics = 39
    
    /// 腰腹训练
    case sportTypeAbdominalAndCoreTraining = 40
    
    /// 下肢训练
    case sportTypeLowerBodyTraining = 41
    
    /// 跳水
    case sportTypeDiving = 43
    
    /// 踏步训练
    case sportTypeSteppingTraining = 44
    
    /// 上肢训练
    case sportTypeUpperBodyTraining = 45
    
    /// 混合有氧
    case sportTypeMixedCardio = 46
    
    /// 背部训练
    case sportTypeBackTraining = 47
    
    /// 户外跑步
    case sportTypeOutdoorRun = 48
    
    /// 室内跑步
    case sportTypeIndoorRun = 49
    
    /// 户外骑行
    case sportTypeOutdoorCycle = 50
    
    /// 室内骑行
    case sportTypeIndoorCycle = 51
    
    /// 户外走路
    case sportTypeOutdoorWalk = 52
    
    /// 室内走路
    case sportTypeIndoorWalk = 53
    
    /// 泳池游泳
    case sportTypePoolSwim = 54
    
    /// 开放水域游泳
    case sportTypeWaterSwim = 55
    
    /// 椭圆机
    case sportTypeElliptical = 56
    
    /// 划船机
    case sportTypeRower = 57
    
    /// 高强度间歇训练法
    case sportTypeHit = 58
    
    /// 踏步测试
    case sportTypeSteppingTest = 59
    
    /// 游戏模式
    case sportTypeGameMode = 60
    
    /// 板球运动
    case sportTypeCricket = 75
    
    /// 自由训练
    case sportTypeFreeTraining = 100
    
    /// 功能性力量训练
    case sportTypeFunctionalStrengthTraining = 101
    
    /// 核心训练
    case sportTypeCoreTraining = 102
    
    /// 踏步机
    case sportTypeStepper = 103
    
    /// 整理放松
    case sportTypeOrganizeAndRelax = 104
    
    /// 传统力量训练
    case sportTypeTraditionalStrengthTraining = 110
    
    /// 引体向上
    case sportTypePullUp = 112
    
    /// 开合跳
    case sportTypeOpeningAndClosingJump = 114
    
    /// 深蹲
    case sportTypeSquat = 115
    
    /// 高抬腿
    case sportTypeHighLegLift = 116
    
    /// 拳击
    case sportTypeBoxing = 117
    
    /// 杠铃
    case sportTypeBarbell = 118
    
    /// 武术
    case sportTypeMartial = 119
    
    /// 太极
    case sportTypeTaiJi = 120
    
    /// 跆拳道
    case sportTypeTaekwondo = 121
    
    /// 空手道
    case sportTypeKarate = 122
    
    /// 自由搏击
    case sportTypeFreeFight = 123
    
    /// 击剑
    case sportTypeFencing = 124
    
    /// 射箭
    case sportTypeArchery = 125
    
    /// 体操
    case sportTypeArtisticGymnastics = 126
    
    /// 单杠
    case sportTypeHorizontalBar = 127
    
    /// 双杠
    case sportTypeParallelBars = 128
    
    /// 漫步机
    case sportTypeWalkingMachine = 129
    
    /// 登山机
    case sportTypeMountaineeringMachine = 130
    
    /// 保龄球
    case sportTypeBowling = 131
    
    /// 台球
    case sportTypeBilliards = 132
    
    /// 曲棍球
    case sportTypeHockey = 133
    
    /// 橄榄球
    case sportTypeRugby = 134
    
    /// 壁球
    case sportTypeSquash = 135
    
    /// 垒球
    case sportTypeSoftball = 136
    
    /// 手球
    case sportTypeHandball = 137
    
    /// 毽球
    case sportTypeShuttlecock = 138
    
    /// 沙滩足球
    case sportTypeBeachSoccer = 139
    
    /// 藤球
    case sportTypeSepaktakraw = 140
    
    /// 躲避球
    case sportTypeDodgeball = 141
    
    /// 无挡板篮球
    case sportTypeNetball = 142
    
    /// 箭步蹲(Lunge)
    case sportTypeLunge = 149
    
    /// 弓箭步
    case sportTypeArcherStep = 150
    
    /// 拉伸
    case sportTypeStretching = 151
    
    /// 街舞
    case sportTypeHiphop = 152
    
    /// 芭蕾
    case sportTypeBallet = 153
    
    /// 社交舞
    case sportTypeSocialDance = 154
    
    /// 飞盘
    case sportTypeFrisbee = 155
    
    /// 飞镖
    case sportTypeDarts = 156
    
    /// 骑马
    case sportTypeRiding = 157
    
    /// 爬楼
    case sportTypeClimbbuilding = 158
    
    /// 放风筝
    case sportTypeflykite = 159
    
    /// 钓鱼
    case sportTypeGofishing = 160
    
    /// 雪橇
    case sportTypeSled = 161
    
    /// 雪车
    case sportTypeSnowmobile = 162
    
    /// 单板滑雪
    case sportTypeSnowboarding = 163
    
    /// 雪上运动
    case sportTypeSnowSports = 164
    
    /// 高山滑雪
    case sportTypeAlpineskiing = 165
    
    /// 越野滑雪
    case sportTypeCrosscountryskiing = 166
    
    /// 冰壶
    case sportTypeCurling = 167
    
    /// 冰球
    case sportTypeIcehockey = 168
    
    /// 冬季两项
    case sportTypeWinterbiathlon = 169
    
    /// 冲浪
    case sportTypeSurfing = 170
    
    /// 帆船
    case sportTypeSailboat = 171
    
    /// 帆板
    case sportTypeSailboard = 172
    
    /// 皮艇
    case sportTypeKayak = 173
    
    /// 摩托艇
    case sportTypeMotorboat = 174
    
    /// 划艇
    case sportTypeRowboat = 175
    
    /// 赛艇
    case sportTypeRowing = 176
    
    /// 龙舟
    case sportTypeDragonBoat = 177
    
    /// 水球
    case sportTypeWaterPolo = 178
    
    /// 漂流
    case sportTypeDrift = 179
    
    /// 滑板
    case sportTypeSkate = 180
    
    /// 攀岩
    case sportTypeRockClimbing = 181
    
    /// 蹦极
    case sportTypeBungeejumping = 182
    
    /// 跑酷
    case sportTypeParkour = 183
    
    /// BMX
    case sportTypeBMX = 184
    
    /// 足排球
    case sportTypeFootVolley = 187
    
    /// 站立滑水
    case sportTypeStandingStroke = 188
    
    /// 越野跑
    case sportTypeTrailRunning = 189
    
    /// 卷腹
    case sportTypeCrunch = 190
    
    /// 波比跳
    case sportTypeBurpee = 191
    
    /// 卡巴迪
    case sportTypeKabaddi = 192
    
    /// 户外玩耍(KR01)
    case sportTypeOutdoorFun = 193
    
    /// 其他运动(KR01)
    case sportTypeOtherActivity = 194
    
    /// 蹦床
    case sportTypeTrampoline = 195
    
    /// 呼啦圈
    case sportTypeHulaHoop = 196
    
    /// 赛车
    case sportTypeRacing = 197
    
    /// 战绳
    case sportTypeBattlingRope = 198
    
    /// 跳伞
    case sportTypeParachuting = 199
    
    /// 定向越野
    case sportTypeOrienteering = 200
    
    /// 山地骑行
    case sportTypeMountainBiking = 201
    
    /// 沙滩网球
    case beachTennis = 202
    
    /// 智能跳绳
    case smartJumpRope = 203
    
    /// 匹克球
    case pickleball = 204
    
    /// 轮椅运动
    case wheelchairSport = 205
    
    /// 体能训练
    case fitnessTraining = 206
    
    /// 壶铃训练
    case kettlebellTraining = 207
    
    /// 团体操
    case groupExercise = 208
    
    /// Cross fit
    case crossFit = 209
    
    /// 障碍赛
    case obstacleCourse = 210
    
    /// 滑板车
    case scooter = 211
    
    /// 滑翔车
    case glider = 212
    
    /// 滑雪
    case skiing = 213
    
    /// 雪板滑雪
    case snowboarding = 214
    
    /// 搏击操
    case combatAerobics = 215
    
    /// 剑道
    case kendo = 216
    
    /// 太极拳
    case taiChi = 217
    
    /// 综合格斗
    case mma = 218
    
    /// 角力
    case wrestling = 219
    
    /// 肚皮舞
    case bellyDance = 220
    
    /// 爵士舞
    case jazzDance = 221
    
    /// 拉丁舞
    case latinDance = 222
    
    /// 踢踏舞
    case tapDance = 223
    
    /// 其他舞蹈
    case otherDance = 224
    
    /// 沙滩排球
    case beachVolleyball = 225
    
    /// 门球
    case gateBall = 226
    
    /// 马球
    case polo = 227
    
    /// 袋棍球
    case lacrosse = 228
    
    /// 皮划艇
    case kayaking = 229
    
    /// 桨板冲浪
    case supSurfing = 230
    
    /// 对战游戏
    case combatGame = 231
    
    /// 拔河
    case tugOfWar = 232
    
    /// 秋千
    case swing = 233
    
    /// 马术运动
    case equestrian = 234
    
    /// 田径
    case trackAndField = 235
    
    /// 爬楼机
    case stairClimber = 236
    
    /// 柔韧训练
    case flexibilityTraining = 237
    
    /// 国际象棋
    case chess = 238
    
    /// 国际跳棋
    case checkers = 239
    
    /// 围棋
    case go = 240
    
    /// 桥牌
    case bridge = 241
    
    /// 桌游
    case boardGame = 242
    
    /// 民族舞
    case ethnicDance = 243
    
    /// 嘻哈舞
    case hipHopDance = 244
    
    /// 钢管舞
    case poleDance = 245
    
    /// 霹雳舞
    case breakDance = 246
    
    /// 现代舞
    case modernDance = 247
    
    /// 泰拳
    case muayThai = 248
    
    /// 柔道
    case judo = 249
    
    /// 柔术
    case jiuJitsu = 250
    
    /// 回力球
    case jaiAlai = 251
    
    /// 雪地摩托
    case snowmobiling = 252
    
    /// 滑翔伞
    case paragliding = 253
    
    /// 长曲棍球
    case lacrosseField = 254
    
    /// 美式橄榄球
    case americanFootball = 255
}
