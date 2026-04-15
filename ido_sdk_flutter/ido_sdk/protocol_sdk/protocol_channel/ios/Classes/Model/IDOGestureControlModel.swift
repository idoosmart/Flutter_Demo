//
//  IDOGestureControlModel.swift
//  IDOBluetooth
//
//  Created by Protocol SDK on 2026/03/12.
//

import Foundation

/// 15.82 手势控制 手势类型细项
@objcMembers
public class IDOGestureTypeItemModel: NSObject, IDOBaseModel {
    /// 手势类型
    public var gestureType: Int = 0

    public override init() {
        super.init()
    }
    
    public init(gestureType: Int) {
        self.gestureType = gestureType
        super.init()
    }
    
    public enum CodingKeys: String, CodingKey {
        case gestureType = "gesture_type"
    }
}

/// 15.82 手势控制 子功能项
@objcMembers
public class IDOGestureSubFunctionItemModel: NSObject, IDOBaseModel {
    /// 子功能类型
    public var subFunctionType: Int = 0
    /// 手势个数
    private var gestureItemCount: Int = 0
    /// 手势类型列表 (IDOGestureTypeItemModel 数组)
    public var gestureTypeItems: [IDOGestureTypeItemModel]? = nil

    public override init() {
        super.init()
    }
    
    public init(subFunctionType: Int, gestureTypeItems: [IDOGestureTypeItemModel]? = nil) {
        self.subFunctionType = subFunctionType
        self.gestureTypeItems = gestureTypeItems
        self.gestureItemCount = gestureTypeItems?.count ?? 0
        super.init()
    }
    
    public enum CodingKeys: String, CodingKey {
        case subFunctionType = "sub_function_type"
        case gestureItemCount = "gesture_item_count"
        case gestureTypeItems = "gesture_type_item"
    }
}

/// 15.82 手势控制 功能项
@objcMembers
public class IDOGestureFunctionItemModel: NSObject, IDOBaseModel {
    /// 功能开关: 1 为开，0 为关
    public var functionSwitch: Int = 0
    /// 功能类型
    public var functionType: Int = 0
    /// 子功能个数
    private var gestureSubFunctionCount: Int = 0
    /// 子功能列表 (IDOGestureSubFunctionItemModel 数组)
    public var gestureSubFunctionItems: [IDOGestureSubFunctionItemModel]? = nil

    public override init() {
        super.init()
    }
    
    public init(functionSwitch: Int, functionType: Int, gestureSubFunctionItems: [IDOGestureSubFunctionItemModel]? = nil) {
        self.functionSwitch = functionSwitch
        self.functionType = functionType
        self.gestureSubFunctionItems = gestureSubFunctionItems
        self.gestureSubFunctionCount = gestureSubFunctionItems?.count ?? 0
        super.init()
    }
    
    public enum CodingKeys: String, CodingKey {
        case functionSwitch = "function_switch"
        case functionType = "function_type"
        case gestureSubFunctionCount = "gesture_sub_function_count"
        case gestureSubFunctionItems = "gesture_sub_function_item"
    }
}

/// 15.82 手势控制参数模型 (设置/获取/获取配置项)
@objcMembers
public class IDOGestureControlModel: NSObject, IDOBaseModel {
    /// 版本号 默认0
    private var version: Int = 0
    /// 操作类型 1 设置，2 获取，3 获取支持配置项
    var operate: Int = 1
    /// 错误码
    public var errCode: Int = 0
    /// 总开关 1 开 0 关
    public var gestureControlOnOff: Int = 0
    /// 功能项个数
    private var gestureFunctionItemCount: Int = 0
    /// 功能列表 (IDOGestureFunctionItemModel 数组)
    public var gestureFunctionItems: [IDOGestureFunctionItemModel]? = nil

    public override init() {
        super.init()
    }

    public init(operate: Int = 1, gestureControlOnOff: Int = 0, gestureFunctionItems: [IDOGestureFunctionItemModel]? = nil) {
        self.operate = operate
        self.gestureControlOnOff = gestureControlOnOff
        self.gestureFunctionItems = gestureFunctionItems
        self.gestureFunctionItemCount = gestureFunctionItems?.count ?? 0
        super.init()
    }
    
    public enum CodingKeys: String, CodingKey {
        case version
        case operate
        case errCode = "err_code"
        case gestureControlOnOff = "gesture_control_on_off"
        case gestureFunctionItemCount = "gesture_function_item_count"
        case gestureFunctionItems = "gesture_function_item"
    }
}
