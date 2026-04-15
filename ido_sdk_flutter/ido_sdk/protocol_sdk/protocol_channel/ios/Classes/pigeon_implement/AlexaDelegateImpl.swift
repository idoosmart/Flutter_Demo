class AlexaDelegateImpl: AlexaDataSource {
    static let shared = AlexaDelegateImpl()
    private init() {}
    
    weak var delegate: IDOAlexaDelegate?
    
    func getHealthValue(valueType: ApiGetValueType, completion: @escaping (Result<Int64, Error>) -> Void) {
        guard let healthValue = delegate?.getHealthValue(valueType: IDOGetValueType(rawValue: valueType.rawValue)!) else {
            completion(.success(0))
            return
        }
        completion(.success(Int64(healthValue)))
    }
    
    func getHrValue(dataType: Int64, timeType: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
        guard let hrValue = delegate?.getHrValue(dataType: Int(dataType), timeType: Int(timeType)) else {
            completion(.success(0))
            return
        }
        completion(.success(Int64(hrValue)))
    }
    
    func functionControl(funType: Int64) throws {
        delegate?.functionControl(funType: Int(funType))
    }
}

class AlexaAuthDelegateImpl: AlexaAuthDelegate {
    static let shared = AlexaAuthDelegateImpl()
    private init() {}
    
    weak var delegate: IDOAlexaAuthDelegate?
    
    func callbackPairCode(userCode: String, verificationUri: String) throws {
        delegate?.callbackPairCode(userCode: userCode, verificationUri: verificationUri)
    }
    
    func loginStateChanged(state: ApiLoginState) throws {
        delegate?.loginStateChanged(state: IDOAlexaLoginState(rawValue: state.rawValue)!)
    }
    
    func voiceStateChanged(state: ApiVoiceState) throws {}
}

// MARK: -

@objc
public protocol IDOAlexaDelegate: NSObjectProtocol {
    /// 获取健康数据
    ///   - Parameters:
    ///   - dataType: 健康数据类型
    /// - Returns: 对应健康数据
    func getHealthValue(valueType: IDOGetValueType) -> Int
    
    /// 获取心率
    /// - Parameters:
    ///   - dataType: 0: 平均，1： 最大，2： 最小
    ///   - timeType: 0：今天，1：上周，2：上个月，3：上一年
    /// - Returns: 心率
    func getHrValue(dataType: Int, timeType: Int) -> Int
    
    /// 功能控制
    ///
    /// funType 0 关闭找手机功能
    func functionControl(funType: Int)
}

// MARK: -

@objc
protocol IDOAlexaAuthDelegate: NSObjectProtocol {
    /// Alexa认证需要打开的url和userCode
    func callbackPairCode(userCode: String, verificationUri: String)
    
    /// 监听登录状态
    ///
    /// state 0 登录中 1 已登录 2 未登录
    func loginStateChanged(state: IDOAlexaLoginState)
    
    /// 监听语音状态 （未启用）
    ///
    /// state 0 无状态 1 准备 2 开始 3 结束
    // func voiceStateChanged(state: Int64)
}

// MARK: -

/// Alexa登录状态
@objc
public enum IDOAlexaLoginState: Int {
    /// 登录中
    case logging = 0
    
    /// 已登录
    case logined
    
    /// 未登录
    case logout
}

/// 健康数据类型
@objc
public enum IDOGetValueType: Int {
    /// 当天步数
    case pedometer = 0
    /// 当天卡路里
    case calorie = 1
    /// 当天最近一次测量的心率
    case heartRate = 2
    /// 当天血氧
    case spO2 = 3
    /// 当天距离（米）
    case kilometer = 4
    /// 当天室内游泳距离（米）
    case swimmingDistance = 5
    /// 当天睡眠得分
    case sleepScore = 6
    /// 当天跑步次数
    case runningCount = 7
    /// 当天游泳次数
    case swimmingCount = 8
    /// 当天运动次数
    case dayWorkoutCount = 9
    /// 当周运动次数
    case weekWorkoutCount = 10
    /// 身体电量
    case bodyBattery = 11
}
