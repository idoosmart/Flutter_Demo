package com.idosmart.enums

/// 状态
enum class IDOSyncStatus(val raw: Int) {
    /// 初始化
    INITSTATUS(0),
    /// 同步中
    SYNCING(1),
    /// 同步完成
    FINISHED(2),
    /// 同步取消
    CANCELED(3),
    /// 同步取消
    STOPPED(4),
    /// 同步超时
    TIMEOUT(5),
    /// 同步错误
    ERROR(6);

    companion object {
        fun ofRaw(raw: Int): IDOSyncStatus? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}

/// 同步数据类型
enum class IDOSyncDataType(val raw: Int) {
    /// 无
    NULLTYPE(0),
    /// 步数
    STEPCOUNT(1),
    /// 心率
    HEARTRATE(2),
    /// 睡眠
    SLEEP(3),
    /// 血压
    BLOODPRESSURE(4),
    /// 血氧
    BLOODOXYGEN(5),
    /// 压力
    PRESSURE(6),
    /// 噪音
    NOISE(7),
    /// 皮温
    PIVEN(8),
    /// 呼吸率
    RESPIRATIONRATE(9),
    /// 身体电量
    BODYPOWER(10),
    /// HRV
    HRV(11),
    /// 多运动
    ACTIVITY(12),
    /// GPS
    GPS(13),
    /// 游泳
    SWIM(14),
    /// 情绪健康
    EMOTIONHEALTH(21),
    /// 多运动/游泳/跑步课程/跑步计划/跑后拉伸数据回调
    ACTIVITYMERGE(22),
    /// 宠物睡眠数据
    PETSLEEP(23);
//    /// V2步数
//    V2STEPCOUNT(15),
//    /// V2睡眠
//    V2SLEEP(16),
//    /// V2心率
//    V2HEARTRATE(17),
//    /// V2血压
//    V2BLOODPRESSURE(18),
//    /// V2GPS
//    V2GPS(19),
//    /// V2多运动
//    V2ACTIVITY(20);

    companion object {
        fun ofRaw(raw: Int): IDOSyncDataType? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}
