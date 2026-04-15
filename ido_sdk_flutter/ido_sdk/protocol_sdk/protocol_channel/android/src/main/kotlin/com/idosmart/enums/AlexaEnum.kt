package com.idosmart.enums

/// Alexa登录状态
enum class IDOAlexaLoginState(val raw: Int) {
    /// 登录中
  LOGGING(0),

    /// 已登录
  LOGINED(1),

    /// 未登录
  LOGOUT(2);

    companion object {
        fun ofRaw(raw: Int): IDOAlexaLoginState? {
            return IDOAlexaLoginState.values().firstOrNull { it.raw == raw }
        }
    }
}

/// 健康数据类型
enum class IDOGetValueType(val raw: Int) {
    /// 当天步数
    PEDOMETER(0),
    /// 当天卡路里
    CALORIE(1),
    /// 当天最近一次测量的心率
    HEARTRATE(2),
    /// 当天血氧
    SPO2(3),
    /// 当天距离（米）
    KILOMETER(4),
    /// 当天室内游泳距离（米）
    SWIMMINGDISTANCE(5),
    /// 当天睡眠得分
    SLEEPSCORE(6),
    /// 当天跑步次数
    RUNNINGCOUNT(7),
    /// 当天游泳次数
    SWIMMINGCOUNT(8),
    /// 当天运动次数
    DAYWORKOUTCOUNT(9),
    /// 当周运动次数
    WEEKWORKOUTCOUNT(10),
    /// 身体电量
    BODYBATTERY(11);

    companion object {
        fun ofRaw(raw: Int): IDOGetValueType? {
            return IDOGetValueType.values().firstOrNull { it.raw == raw }
        }
    }
}

/// alexa授权登录结果
enum class IDOAlexaAuthorizeResult(val raw: Int) {
    /// 成功
    SUCCESSFUL(0),

    /// 失败
    FAILURE(1),

    /// 超时
    TIMEOUT(3);

    companion object {
        fun ofRaw(raw: Int): IDOAlexaAuthorizeResult? {
            return IDOAlexaAuthorizeResult.values().firstOrNull { it.raw == raw }
        }
    }
}