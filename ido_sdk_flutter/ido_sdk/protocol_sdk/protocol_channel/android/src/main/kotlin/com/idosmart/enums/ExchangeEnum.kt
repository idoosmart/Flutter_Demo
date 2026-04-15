package com.idosmart.enums

/// 交换数据状态
enum class IDOExchangeStatus(val raw: Int) {
    INITIAL(0),

    /// 初始化
    APPSTART(1),

    /// APP发起开始
    APPSTARTREPLY(2),

    /// APP发起开始 BLE回复
    APPEND(3),

    /// APP发起结束
    APPENDREPLY(4),

    /// APP发起结束 BLE回复
    APPPAUSE(5),

    /// APP发起暂停
    APPPAUSEREPLY(6),

    /// APP发起暂停 BLE回复
    APPRESTORE(7),

    /// APP发起恢复
    APPRESTOREREPLY(8),

    /// APP发起恢复 BLE回复
    APPING(9),

    /// APP发起交换
    APPINGREPLY(10),

    /// APP发起交换 BLE回复
    GETACTIVITY(11),

    /// 获取最后运动数据
    GETACTIVITYREPLY(12),

    /// 获取最后运动数据 BLE回复
    GETHR(13),

    /// 获取一分钟心率
    GETHRREPLY(14),

    /// 获取一分钟心率 BLE回复
    APPSTARTPLAN(15),

    /// APP开始运动计划
    APPSTARTPLANREPLY(16),

    /// APP开始运动计划 BLE回复
    APPPAUSEPLAN(17),

    /// APP暂停运动计划
    APPPAUSEPLANREPLY(18),

    /// APP暂停运动计划 BLE回复
    APPRESTOREPLAN(19),

    /// APP恢复运动计划
    APPRESTOREPLANREPLY(20),

    /// APP恢复运动计划 BLE回复
    APPENDPLAN(21),

    /// APP结束运动计划
    APPENDPLANREPLY(22),

    /// APP结束运动计划 BLE回复
    APPSWITCHACTION(23),

    /// APP切换动作
    APPSWITCHACTIONREPLY(24),

    /// APP结束运动计划 BLE回复
    APPBLEPAUSE(25),

    /// APP发起的运动 BLE发起暂停
    APPBLEPAUSEREPLY(26),

    /// APP发起的运动 BLE发起暂停 APP回复
    APPBLERESTORE(27),

    /// APP发起的运动 BLE发起恢复
    APPBLERESTOREREPLY(28),

    /// APP发起的运动 BLE发起恢复 APP回复
    APPBLEEND(29),

    /// APP发起的运动 BLE发起结束
    APPBLEENDREPLY(30),

    /// APP发起的运动 BLE发起结束 APP回复
    BLESTART(31),

    /// BLE发起的运动 BLE发起开始
    BLESTARTREPLY(32),

    /// BLE发起的运动 BLE发起开始 APP回复
    BLEEND(33),

    /// BLE发起的运动 BLE发起结束
    BLEENDREPLY(34),

    /// BLE发起的运动 BLE发起结束 APP回复
    BLEPAUSE(35),

    /// BLE发起的运动 BLE发起暂停
    BLEPAUSEREPLY(36),

    /// BLE发起的运动 BLE发起暂停 APP回复
    BLERESTORE(37),

    /// BLE发起的运动 BLE发起恢复
    BLERESTOREREPLY(38),

    /// BLE发起的运动 BLE发起恢复 APP回复
    BLEING(39),

    /// BLE发起的运动 BLE发起交换
    BLEINGREPLY(40),

    /// BLE发起的运动 BLE发起交换 APP回复
    BLESTARTPLAN(41),

    /// BLE开始运动计划
    BLEPAUSEPLAN(42),

    /// BLE暂停运动计划
    BLERESTOREPLAN(43),

    /// BLE恢复运动计划
    BLEENDPLAN(44),

    /// BLE结束运动计划
    BLESWITCHACTION(45),

    /// BLE切换动作
    BLEOPERATEPLANREPLY(46);

    companion object {
        fun ofRaw(raw: Int): IDOExchangeStatus? {
            return IDOExchangeStatus.values().firstOrNull { it.raw == raw }
        }
    }
}
