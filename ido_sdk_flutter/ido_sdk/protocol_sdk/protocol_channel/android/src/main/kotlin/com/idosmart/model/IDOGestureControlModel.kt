package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

/**
 * 15.82 手势控制参数模型
 */
class IDOGestureControlModel(
    /** 操作类型 1 设置，2 获取，3 获取支持配置项 */
    internal var operate: Int = 1,
    /** 错误码 */
    @SerializedName("err_code")
    var errCode: Int = 0,
    /** 总开关 1 开 0 关 */
    @SerializedName("gesture_control_on_off")
    var gestureControlOnOff: Int = 0,
    /** 功能列表 */
    @SerializedName("gesture_function_item")
    var gestureFunctionItems: List<IDOGestureFunctionItemModel>? = null
) : IDOBaseModel {
    /** 版本号 默认0 */
    @SerializedName("version")
    private var version: Int = 0

    /** 功能项个数 */
    @SerializedName("gesture_function_item_count")
    private var gestureFunctionItemCount: Int = 0

    init {
        gestureFunctionItemCount = gestureFunctionItems?.size ?: 0
    }

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

class IDOGestureFunctionItemModel(
    /** 功能开关: 1 为开，0 为关 */
    @SerializedName("function_switch")
    var functionSwitch: Int = 0,
    /** 功能类型 */
    @SerializedName("function_type")
    var functionType: Int = 0,
    /** 子功能列表 */
    @SerializedName("gesture_sub_function_item")
    var gestureSubFunctionItems: List<IDOGestureSubFunctionItemModel>? = null
) : IDOBaseModel {
    /** 子功能个数 */
    @SerializedName("gesture_sub_function_count")
    private var gestureSubFunctionCount: Int = 0

    init {
        gestureSubFunctionCount = gestureSubFunctionItems?.size ?: 0
    }

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

class IDOGestureSubFunctionItemModel(
    /** 子功能类型 */
    @SerializedName("sub_function_type")
    var subFunctionType: Int = 0,
    /** 手势类型列表 */
    @SerializedName("gesture_type_item")
    var gestureTypeItems: List<IDOGestureTypeItemModel>? = null
) : IDOBaseModel {
    /** 手势个数 */
    @SerializedName("gesture_item_count")
    private var gestureItemCount: Int = 0

    init {
        gestureItemCount = gestureTypeItems?.size ?: 0
    }

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}

class IDOGestureTypeItemModel(
    /** 手势类型 */
    @SerializedName("gesture_type")
    var gestureType: Int = 0
) : IDOBaseModel {
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
