package com.idosmart.enums

/// 日志类型 （只针对控制台）
enum class IDOLogType(val raw: Int) {
    /// 不打印
    NONE(0),

    /// 详细
    DEBUG(1),

    /// 重要
    RELEASE(2);

    companion object {
        fun ofRaw(raw: Int): IDOLogType? {
            return IDOLogType.values().firstOrNull { it.raw == raw }
        }
    }
}


/// OTA类型
enum class IDOOtaType(val raw: Int) {
    /// 无升级
    NONE(0),
    /// 泰凌微设备OTA
    TELINK(1),
    /// NORDIC设备OTA
    NORDIC(2);

    companion object {
        fun ofRaw(raw: Int): IDOOtaType? {
            return IDOOtaType.values().firstOrNull { it.raw == raw }
        }
    }

}

/** 状态通知 */
enum class IDOStatusNotification(val raw: Int) {
    /** 协议库完成蓝牙库桥接，此时缓存数据已经初始化 */
    PROTOCOLCONNECTCOMPLETED(0),
    /** 功能表获取完成 */
    FUNCTIONTABLEUPDATECOMPLETED(1),
    /** 设备信息获取完成 */
    DEVICEINFOUPDATECOMPLETED(2),
    /** 三级版本获取完成 */
    DEVICEINFOFWVERSIONCOMPLETED(3),
    /** 绑定授权码异常，设备强制解绑 */
    UNBINDONAUTHCODEERROR(4),
    /** 绑定状态异常，需要解绑 (本地绑定状态和设备信息不一致时触发) */
    UNBINDONBINDSTATEERROR(5),
    /** 快速配置完成 */
    FASTSYNCCOMPLETED(6),
    /** 快速配置失败，需业务层重新触发快速配置 */
    FASTSYNCFAILED(7),
    /** BT MACADDRESS获取完成 */
    DEVICEINFOBTADDRESSUPDATECOMPLETED(8),
    /** 快速配置获取到的MACADDRESS和MARKCONNECTEDDEVICE传入的不一致时上报此错误 */
    MACADDRESSERROR(9),
    /** 同步健康数据中 */
    SYNCHEALTHDATAING(10),
    /** 同步健康数据完成 */
    SYNCHEALTHDATACOMPLETED(11),
    /** 成功 / 一致（恒玄专用） */
    ACCOUNTMATCHED(12),
    /** 失败（恒玄专用） */
    ACCOUNTFAILED(13),
    /** 失败，账号不一致（恒玄专用） */
    ACCOUNTNOTMATCH(14),
    /** 失败，无账户（恒玄专用） */
    ACCOUNTNIL(15),
    /** 快速配置开始 */
    FASTSYNCSTARTING(16);

    companion object {
        fun ofRaw(raw: Int): IDOStatusNotification? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}