package com.idosmart.enums

/// 连接状态
enum class IDODeviceStateType(val raw: Int) {
    /// 断开连接，
    DISCONNECTED(0),
    /// 连接中，
    CONNECTING(1),
    /// 已连接，
    CONNECTED(2),
    /// 断开连接中
    DISCONNECTING(3);

    companion object {
        fun ofRaw(raw: Int): IDODeviceStateType? {
            return IDODeviceStateType.values().firstOrNull { it.raw == raw }
        }
    }
}

/// 蓝牙状态
enum class IDOBluetoothStateType(val raw: Int) {
    /// 未知
    UNKNOWN(0),
    /// 系统服务重启中
    RESETTING(1),
    /// 不支持
    UNSUPPORTED(2),
    /// 未授权
    UNAUTHORIZED(3),
    /// 蓝牙关闭
    POWEREDOFF(4),
    /// 蓝牙打开
    POWEREDON(5);

    companion object {
        fun ofRaw(raw: Int): IDOBluetoothStateType? {
            return IDOBluetoothStateType.values().firstOrNull { it.raw == raw }
        }
    }
}

/// 扫描状态
enum class IDOBluetoothScanType(val raw: Int) {
    /// 扫描中
    SCANNING(0),
    /// 扫描结束
    STOP(1),
    /// 找到设备（ANDROID）
    FIND(2);

    companion object {
        fun ofRaw(raw: Int): IDOBluetoothScanType? {
            return IDOBluetoothScanType.values().firstOrNull { it.raw == raw }
        }
    }
}

/// 连接错误
enum class IDOConnectErrorType(val raw: Int) {
    /// 无状态
    NONE(0),
    /// UUID或MAC地址异常
    ABNORMALUUIDMACADDRESS(1),
    /// 蓝牙关闭
    BLUETOOTHOFF(2),
    /// 主动断开连接
    CONNECTCANCEL(3),
    /// 连接失败
    FAIL(4),
    /// 连接超时
    TIMEOUT(5),
    /// 发现服务失败
    SERVICEFAIL(6),
    /// 发现特征失败
    CHARACTERISTICSFAIL(7),
    /// 配对异常
    PAIRFAIL(8),
    /// 获取基本信息失败
    INFORMATIONFAIL(9),
    CANCELBYUSER(10),
    /// 设备已绑定并且不支持重复绑定
    DEVICEALREADYBINDANDNOTSUPPORTREBIND(11),
    /// app 绑定的设备被重置了
    DEVICEHASBEENRESET(12),
    /// 连接被终止，比如在 ota 中，不需要执行重连了
    CONNECTTERMINATED(13);


    companion object {
        fun ofRaw(raw: Int): IDOConnectErrorType? {
            return IDOConnectErrorType.values().firstOrNull { it.raw == raw }
        }
    }
}

/// 写数据状态
enum class IDOWriteType(val raw: Int) {
    /// 有响应
    WITHRESPONSE(0),
    /// 无响应
    WITHOUTRESPONSE(1),
    /// 错误
    ERROR(2);

    companion object {
        fun ofRaw(raw: Int): IDOWriteType? {
            return IDOWriteType.values().firstOrNull { it.raw == raw }
        }
    }
}

/// spp
enum class IDOSppStateType(val raw: Int) {
    /// 开始连接
    ONSTART(0),
    /// 连接成功
    ONSUCCESS(1),
    /// 连接失败
    ONFAIL(2),
    /// 断链
    ONBREAK(3);

    companion object {
        fun ofRaw(raw: Int): IDOSppStateType? {
            return IDOSppStateType.values().firstOrNull { it.raw == raw }
        }
    }
}