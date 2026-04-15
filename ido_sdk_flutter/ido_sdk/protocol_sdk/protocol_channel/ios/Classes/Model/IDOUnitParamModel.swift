//
//  IDOUnitParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set Unit event number
@objcMembers
public class IDOUnitParamModel: NSObject, IDOBaseModel {
    /// Distance Unit:
    /// 0: Invalid
    /// 1: km (metric)
    /// 2: mi (imperial)
    public var distUnit: Int
    /// Weight Unit:
    /// 0: Invalid
    /// 1: kg
    /// 2: lb
    public var weightUnit: Int
    /// Temperature Unit:
    /// 0: Invalid<br/>1: ℃
    /// 2: ℉
    public var temp: Int
    /// Walking Stride:
    /// 0: Invalid
    /// 0: cm
    public var stride: Int
    
    /// Language
    /// | 代码 | 语言         | 功能表                      |
    /// | ---- | ------------ | --------------------------- |
    /// | -1   | 无效         | -                           |
    /// | 1    | 中文         | languageCh                  |
    /// | 2    | 英文         | languageEnglish             |
    /// | 3    | 法语         | languageFrench              |
    /// | 4    | 德语         | languageGerman              |
    /// | 5    | 意大利语     | languageItalian             |
    /// | 6    | 西班牙语     | languageSpanish             |
    /// | 7    | 日语         | languageJapanese            |
    /// | 8    | 波兰语       | languagePolish              |
    /// | 9    | 捷克语       | languageCzech               |
    /// | 10   | 罗马尼亚     | languageRomanian            |
    /// | 11   | 立陶宛语     | languageLithuanian          |
    /// | 12   | 荷兰语       | languageDutch               |
    /// | 13   | 斯洛文尼亚语 | languageSlovenian           |
    /// | 14   | 匈牙利语     | languageHungarian           |
    /// | 15   | 俄罗斯语     | languageRussian             |
    /// | 16   | 乌克兰语     | languageUkrainian           |
    /// | 17   | 斯洛伐克语   | languageSlovak              |
    /// | 18   | 丹麦语       | languageDanish              |
    /// | 19   | 克罗地亚语   | languageCroatian            |
    /// | 20   | 印尼语       | languageIndonesian          |
    /// | 21   | 韩语         | languageKorean              |
    /// | 22   | 印地语       | languageHindi               |
    /// | 23   | 葡萄牙语     | languagePortuguese          |
    /// | 24   | 土耳其语     | languageTurkish             |
    /// | 25   | 泰国语       | languageThai                |
    /// | 26   | 越南语       | languageVietnamese          |
    /// | 27   | 缅甸语       | languageBurmese             |
    /// | 28   | 菲律宾语     | languageFilipino            |
    /// | 29   | 繁体中文     | languageTraditionalChinese  |
    /// | 30   | 希腊语       | languageGreek               |
    /// | 31   | 阿拉伯语     | languageArabic              |
    /// | 32   | 瑞典语       | languageSweden              |
    /// | 33   | 芬兰语       | languageFinland             |
    /// | 34   | 波斯语       | languagePersia              |
    /// | 35   | 挪威语       | languageNorwegian           |
    /// | 36   | 马来语       | languageMalay               |
    /// | 37   | 巴西葡语     | languageBrazilianPortuguese |
    /// | 38   | 孟加拉语     | languageBengali             |
    /// | 39   | 高棉语       | languageKhmer               |
    public var language: Int
    /// Time Format:
    /// 0: Invalid<br/>1: 24-hour format
    /// 2: 12-hour format
    public var is12HourFormat: Int
    /// Running Stride:
    /// 0: Invalid
    /// 1: cm
    /// Default value for males: 90cm
    public var strideRun: Int
    /// Stride Calibration via GPS on/off:<br/>0: Invalid
    /// 1: On
    /// 2: Off
    public var strideGpsCal: Int
    /// Start day of the week:
    /// 0: Monday
    /// 1: Sunday
    /// 3: Saturday
    public var weekStartDate: Int
    /// Calorie unit setting:
    /// 0: Invalid
    /// 1: Default kCal
    /// 2: Cal
    /// 3: kJ
    public var calorieUnit: Int
    /// Swim pool unit setting:
    /// 0: Invalid
    /// 1: Default meters
    /// 2: yards
    public var swimPoolUnit: Int
    /// Cycling unit:
    /// 0: Invalid
    /// 1: km
    /// 2: miles
    public var cyclingUnit: Int
    /// Unit for walking or running (km/miles) setting:<br/>0: Invalid
    /// 1: km
    /// 2: miles
    /// Requires support from the device firmware `setSupportWalkRunUnit`
    public var walkingRunningUnit: Int
    
    ///
    /////身高单位 0：无效，1：cm，2：inch 英寸；功能表：``
    public var heightUnit: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case distUnit = "dist_unit"
        case weightUnit = "weight_unit"
        case temp = "temp"
        case stride = "stride"
        case language = "language"
        case is12HourFormat = "is_12hour_format"
        case strideRun = "stride_run"
        case strideGpsCal = "stride_gps_cal"
        case weekStartDate = "week_start_date"
        case calorieUnit = "calorie_unit"
        case swimPoolUnit = "swim_pool_unit"
        case cyclingUnit = "cycling_unit"
        case walkingRunningUnit = "walking_running_unit"
        case heightUnit = "height_unit"
    }

    public init(distUnit: Int, weightUnit: Int, temp: Int, stride: Int, language: Int, is12HourFormat: Int, strideRun: Int, strideGpsCal: Int, weekStartDate: Int, calorieUnit: Int, swimPoolUnit: Int, cyclingUnit: Int, walkingRunningUnit: Int = 0) {
        self.distUnit = distUnit
        self.weightUnit = weightUnit
        self.temp = temp
        self.stride = stride
        self.language = language
        self.is12HourFormat = is12HourFormat
        self.strideRun = strideRun
        self.strideGpsCal = strideGpsCal
        self.weekStartDate = weekStartDate
        self.calorieUnit = calorieUnit
        self.swimPoolUnit = swimPoolUnit
        self.cyclingUnit = cyclingUnit
        self.walkingRunningUnit = walkingRunningUnit
    }

    public init(distUnit: Int, weightUnit: Int, temp: Int, stride: Int, language: Int, is12HourFormat: Int, strideRun: Int, strideGpsCal: Int, weekStartDate: Int, calorieUnit: Int, swimPoolUnit: Int, cyclingUnit: Int, walkingRunningUnit: Int = 0, heightUnit: Int = 0) {
        self.distUnit = distUnit
        self.weightUnit = weightUnit
        self.temp = temp
        self.stride = stride
        self.language = language
        self.is12HourFormat = is12HourFormat
        self.strideRun = strideRun
        self.strideGpsCal = strideGpsCal
        self.weekStartDate = weekStartDate
        self.calorieUnit = calorieUnit
        self.swimPoolUnit = swimPoolUnit
        self.cyclingUnit = cyclingUnit
        self.walkingRunningUnit = walkingRunningUnit
        self.heightUnit = heightUnit
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}


@objcMembers
public class IDOUnitModel: NSObject, IDOBaseModel {
    /// Distance Unit:
    /// 0: Invalid
    /// 1: km (metric)
    /// 2: mi (imperial)
    public var distUnit: Int
    /// Temperature Unit:
    /// 0: Invalid<br/>1: ℃
    /// 2: ℉
    public var temp: Int
    
    /// Language
    /// | 代码 | 语言         | 功能表                      |
    /// | ---- | ------------ | --------------------------- |
    /// | -1   | 无效         | -                           |
    /// | 1    | 中文         | languageCh                  |
    /// | 2    | 英文         | languageEnglish             |
    /// | 3    | 法语         | languageFrench              |
    /// | 4    | 德语         | languageGerman              |
    /// | 5    | 意大利语     | languageItalian             |
    /// | 6    | 西班牙语     | languageSpanish             |
    /// | 7    | 日语         | languageJapanese            |
    /// | 8    | 波兰语       | languagePolish              |
    /// | 9    | 捷克语       | languageCzech               |
    /// | 10   | 罗马尼亚     | languageRomanian            |
    /// | 11   | 立陶宛语     | languageLithuanian          |
    /// | 12   | 荷兰语       | languageDutch               |
    /// | 13   | 斯洛文尼亚语 | languageSlovenian           |
    /// | 14   | 匈牙利语     | languageHungarian           |
    /// | 15   | 俄罗斯语     | languageRussian             |
    /// | 16   | 乌克兰语     | languageUkrainian           |
    /// | 17   | 斯洛伐克语   | languageSlovak              |
    /// | 18   | 丹麦语       | languageDanish              |
    /// | 19   | 克罗地亚语   | languageCroatian            |
    /// | 20   | 印尼语       | languageIndonesian          |
    /// | 21   | 韩语         | languageKorean              |
    /// | 22   | 印地语       | languageHindi               |
    /// | 23   | 葡萄牙语     | languagePortuguese          |
    /// | 24   | 土耳其语     | languageTurkish             |
    /// | 25   | 泰国语       | languageThai                |
    /// | 26   | 越南语       | languageVietnamese          |
    /// | 27   | 缅甸语       | languageBurmese             |
    /// | 28   | 菲律宾语     | languageFilipino            |
    /// | 29   | 繁体中文     | languageTraditionalChinese  |
    /// | 30   | 希腊语       | languageGreek               |
    /// | 31   | 阿拉伯语     | languageArabic              |
    /// | 32   | 瑞典语       | languageSweden              |
    /// | 33   | 芬兰语       | languageFinland             |
    /// | 34   | 波斯语       | languagePersia              |
    /// | 35   | 挪威语       | languageNorwegian           |
    /// | 36   | 马来语       | languageMalay               |
    /// | 37   | 巴西葡语     | languageBrazilianPortuguese |
    /// | 38   | 孟加拉语     | languageBengali             |
    /// | 39   | 高棉语       | languageKhmer               |
    public var language: Int
    
    /// Swim pool unit setting:
    /// 0: Invalid
    /// 1: Default meters
    /// 2: yards
    public var swimPoolUnit: Int
    
    
    enum CodingKeys: String, CodingKey {
        case distUnit = "dist_unit"
        case temp = "temp"
        case language = "language"
        case swimPoolUnit = "swim_pool_unit"
    }
    
    public init(distUnit: Int, temp: Int, language: Int, swimPoolUnit: Int) {
        self.distUnit = distUnit
        self.temp = temp
        self.language = language
        self.swimPoolUnit = swimPoolUnit
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

