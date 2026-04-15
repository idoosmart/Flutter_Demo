package com.idosmart.enums

/// 日志类型
enum class IDODeviceLogType(val raw: Int) {
    /// 无
    INITIAL(0),
    /// 旧的重启日志
    REBOOT(1),
    /// 通用日志
    GENERAL(2),
    /// 复位日志
    RESET(3),
    /// 硬件日志
    HARDWARE(4),
    /// 算法日志
    ALGORITHM(5),
    /// 新重启日志
    RESTART(6),
    /// 电池日志
    BATTERY(7),
    /// 过热日志
    HEAT(8);

    companion object {
        fun ofRaw(raw: Int): IDODeviceLogType? {
            return values().firstOrNull { it.raw == raw }
        }
    }
}
