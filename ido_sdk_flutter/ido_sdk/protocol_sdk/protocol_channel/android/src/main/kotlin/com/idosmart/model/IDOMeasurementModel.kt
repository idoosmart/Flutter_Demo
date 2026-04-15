package com.idosmart.model

import com.google.gson.GsonBuilder
import com.google.gson.annotations.SerializedName

/**
 * 测量类型 | Measurement Type
 */
enum class IDOMeasurementType(val jsonKey: String) {
    /** 血压 | Blood Pressure */
    BLOOD_PRESSURE("flag"),
    /** 血氧 | SpO2 */
    SPO2("spo2_flag"),
    /** 心率 | Heart Rate */
    HEART_RATE("hr_flag"),
    /** 体成分 | Body Composition */
    BODY_COMPOSITION("body_composition_flag"),
    /** 压力 | Stress */
    STRESS("stress_flag"),
    /** 一键测量 | One-click Measurement */
    ONE_CLICK("one_click_measure_flag"),
    /** 体温 | Temperature */
    TEMPERATURE("temperature_flag")
}

/**
 * 测量操作 | Measurement Action
 */
enum class IDOMeasurementAction(val raw: Int) {
    /** 开始 | Start */
    START(1),
    /** 停止 | Stop */
    STOP(2),
    /** 获取数据 | Get Data */
    GET_DATA(3)
}

/**
 * 通用测量结果模型 | General Measurement Model
 */
open class IDOMeasurementModel : IDOBaseModel {
    /** 0:不支持 1:进行中 2:成功 3:失败 4:设备在运动模式 | 0:Not support 1:In progress 2:Success 3:Fail 4:Exercise mode */
    @SerializedName("status")
    var status: Int = 0

    /** 高压（收缩压），`BLOOD_PRESSURE`类型获取有效 | Systolic blood pressure, valid for `BLOOD_PRESSURE` */
    @SerializedName("systolic_bp")
    var systolicBp: Int = 0

    /** 低压（舒张压），`BLOOD_PRESSURE`类型获取有效 | Diastolic blood pressure, valid for `BLOOD_PRESSURE` */
    @SerializedName("diastolic_bp")
    var diastolicBp: Int = 0

    /** 心率/血氧值/压力值，对应`HEART_RATE` / `SPO2` / `STRESS`类型获取有效 | Value (HR/SpO2/Stress), valid for `HEART_RATE`/`SPO2`/`STRESS` */
    @SerializedName("value")
    var value: Int = 0

    /** 心率，`ONE_CLICK`一键测量类型获取有效 | Heart rate, valid for `ONE_CLICK` */
    @SerializedName("one_click_measure_hr")
    var oneClickHr: Int = 0

    /** 压力，`ONE_CLICK`一键测量类型获取有效 | Stress, valid for `ONE_CLICK` */
    @SerializedName("one_click_measure_stress")
    var oneClickStress: Int = 0

    /** 血氧，`ONE_CLICK`一键测量类型获取有效 | SpO2, valid for `ONE_CLICK` */
    @SerializedName("one_click_measure_spo2")
    var oneClickSpo2: Int = 0

    /** 体温值，`TEMPERATURE`类型获取有效（乘以10倍的整数值）| Temperature, valid for `TEMPERATURE` (multiplied by 10) */
    @SerializedName("temperature_value")
    var temperature: Float = 0f

    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
}
