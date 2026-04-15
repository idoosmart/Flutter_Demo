package com.idosmart.enums

/// 传输文件类型
enum class IDOTransType(val raw: Int) {
    /** 固件升级 */
    FW(0),

    /** 图片资源升级 */
    FZBIN(1),

    /** 字库升级 */
    BIN(2),

    /** 语言包升级 */
    LANG(3),

    /** BT升级 */
    BT(4),

    /** 表盘 */
    IWFLZ(5),

    /** 表盘 思澈 */
    WATCH(6),

    /** 壁纸表盘 */
    WALLPAPERZ(7),

    /** 通讯录文件 */
    ML(8),

    /** agps 在线 */
    ONLINEUBX(9),

    /** agps 线下 */
    OFFLINEUBX(10),

    /** 音乐（使用 IDOTransMusicModel） */
    MP3(11),

    /** 消息图标 （使用 IDOTransMessageModel） */
    @Deprecated("已废弃")
    MSG(12),

    /** 运动图标 - 单个（IDOTransSportModel） */
    SPORT(13),

    /** 运动图标 - 动画（IDOTransSportModel） */
    SPORTS(14),

    /** epo升级 */
    EPO(15),

    /** gps */
    GPS(16),

    BPBIN(17),

    /** alexa 语音 */
    VOICE(18),

    /** 提示音 */
    TON(19),

    /** 小程序 */
    APP(20),
    /**
     * 其它类型：不限后缀，不对文件二次加工，直接上传到设备
     * ```
     * hid: 检测引导程序hid更新(android专用)
     * xx: xxxxx
     * ```
     */
    OTHER(21);

    companion object {
        fun ofRaw(raw: Int): IDOTransType? {
            return IDOTransType.values().firstOrNull { it.raw == raw }
        }
    }
}

///传输状态
enum class IDOTransStatus(val raw: Int) {
    NONE(0),

    /// 无效类型
    INVALID(1),

    /// 文件不存在
    NOTEXISTS(2),

    /// 存在传输任务
    BUSY(3),

    /// 配置
    CONFIG(4),

    /// 传输前操作
    BEFOREOPT(5),

    /// 传输中
    TRANS(6),

    /// 传输完成
    FINISHED(7),

    /// 快速配置中，不支持文件传输
    ONFASTSYNCHRONIZING(8),

    /// 传输失败
    ERROR(9);

    companion object {
        fun ofRaw(raw: Int): IDOTransStatus? {
            return IDOTransStatus.values().firstOrNull { it.raw == raw }
        }
    }
}