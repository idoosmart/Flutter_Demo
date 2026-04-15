//
//  IDOMenuListV3Model.swift
//  protocol_channel
//
//  Created by hc on 2025/12/04.
//

import Foundation

/// 协议V3菜单列表模型
@objcMembers
internal class IDOMenuListV3ParamModel: NSObject, IDOBaseModel {
    /// 版本号，默认为0
    private var version: Int
    
    /// 操作类型
    /// - 1: 设置
    /// - 2: 查询
    public var operate: Int
    
    /// 菜单项个数，设置操作时有效
    private var itemListNum: Int
    
    /// 菜单项列表，自带排序，最大100个，设置操作时有效
    /// - 无排序情况：有值则显示，无值则不显示
    /// - 有排序情况：需要按照数组从0开始依次显示
    /// ```
    /// 0x00 无效
    /// 0x01 步数
    /// 0x02 心率
    /// 0x03 睡眠
    /// 0x04 拍照
    /// 0x05 闹钟
    /// 0x06 音乐
    /// 0x07 秒表
    /// 0x08 计时器
    /// 0x09 运动模式
    /// 0x0A 天气
    /// 0x0B 呼吸锻炼
    /// 0x0C 查找手机
    /// 0x0D 压力
    /// 0x0E 数据三环
    /// 0x0F 时间界面
    /// 0x10 最近一次活动
    /// 0x11 健康数据
    /// 0x12 血氧
    /// 0x13 菜单设置
    /// 0x14 Alexa语音依次显示
    /// 0x15 X屏（gt01pro-X新增）
    /// 0x16 卡路里（Doro Watch新增）
    /// 0x17 距离（Doro Watch新增）
    /// 0x18 一键测量（IDW05新增）
    /// 0x19 Renpho Health润丰健康（IDW12新增）
    /// 0x1A 指南针（mp01新增）
    /// 0x1B 气压高度计（mp01新增）
    /// 0x1C 通话列表/蓝牙通话（IDW13新增）
    /// 0x1D 事项提醒
    /// 0x1E ICE紧急联系人咨询
    /// 0x1F 最大摄氧量
    /// 0x20 恢复时间
    /// 0x21 有氧训练效果
    /// 0x22 海拔高度
    /// 0x23 身体电量
    /// 0x24 世界时钟
    /// 0x25 语音助手
    /// 0x26 AI语音助手
    /// 0x27 支付宝
    /// ```
    public var itemList: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case operate = "operate"
        case itemListNum = "item_list_num"
        case itemList = "item_list"
    }
    
    public init(operate: Int, itemList: [Int]? = nil) {
        self.version = 0
        self.operate = operate
        self.itemList = itemList
        self.itemListNum = itemList?.count ?? 0
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// 协议V3菜单列表回复模型
@objcMembers
public class IDOMenuListV3Model: NSObject, IDOBaseModel {
    /// 版本号，默认为0
    private var version: Int

    /// 操作类型
    /// - 1: 设置
    /// - 2: 查询
    public var operate: Int
    
    /// 错误码
    /// - 0: 成功
    /// - 1: 失败
    public var errorCode: Int
    
    /// 最小显示个数，查询操作时有效
    public var minShowNum: Int
    
    /// 最大显示个数，查询操作时有效
    public var maxShowNum: Int
    
    /// 设备当前显示的列表个数，查询操作时有效
    public var currentShowNum: Int
    
    /// 支持显示个数，查询操作时有效
    public var supportMaxNum: Int
    
    /// 菜单项列表，自带排序，最大100个，查询操作时有效
    /// - 无排序情况：有值则显示，无值则不显示
    /// - 有排序情况：需要按照数组从0开始依次显示
    /// ```
    /// 0x00 无效
    /// 0x01 步数
    /// 0x02 心率
    /// 0x03 睡眠
    /// 0x04 拍照
    /// 0x05 闹钟
    /// 0x06 音乐
    /// 0x07 秒表
    /// 0x08 计时器
    /// 0x09 运动模式
    /// 0x0A 天气
    /// 0x0B 呼吸锻炼
    /// 0x0C 查找手机
    /// 0x0D 压力
    /// 0x0E 数据三环
    /// 0x0F 时间界面
    /// 0x10 最近一次活动
    /// 0x11 健康数据
    /// 0x12 血氧
    /// 0x13 菜单设置
    /// 0x14 Alexa语音依次显示
    /// 0x15 X屏（gt01pro-X新增）
    /// 0x16 卡路里（Doro Watch新增）
    /// 0x17 距离（Doro Watch新增）
    /// 0x18 一键测量（IDW05新增）
    /// 0x19 Renpho Health润丰健康（IDW12新增）
    /// 0x1A 指南针（mp01新增）
    /// 0x1B 气压高度计（mp01新增）
    /// 0x1C 通话列表/蓝牙通话（IDW13新增）
    /// 0x1D 事项提醒
    /// 0x1E ICE紧急联系人咨询
    /// 0x1F 最大摄氧量
    /// 0x20 恢复时间
    /// 0x21 有氧训练效果
    /// 0x22 海拔高度
    /// 0x23 身体电量
    /// 0x24 世界时钟
    /// 0x25 语音助手
    /// 0x26 AI语音助手
    /// 0x27 支付宝
    /// ```
    public var itemList: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case operate = "operate"
        case errorCode = "error_code"
        case minShowNum = "min_show_num"
        case maxShowNum = "max_show_num"
        case currentShowNum = "current_show_num"
        case supportMaxNum = "support_max_num"
        case itemList = "item_list"
    }
    
    public init(version: Int = 0, operate: Int, errorCode: Int, minShowNum: Int = 0, maxShowNum: Int = 0, currentShowNum: Int = 0, supportMaxNum: Int = 0, itemList: [Int]? = nil) {
        self.version = version
        self.operate = operate
        self.errorCode = errorCode
        self.minShowNum = minShowNum
        self.maxShowNum = maxShowNum
        self.currentShowNum = currentShowNum
        self.supportMaxNum = supportMaxNum
        self.itemList = itemList
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}