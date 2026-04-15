package com.idosmart.enums

enum class IDOBindStatus(val raw: Int) {
    /// 绑定失败
    FAILED(0),
    /// 绑定成功
    SUCCESSFUL(1),
    /// 已经绑定
    BINDED(2),
    /// 需要授权码绑定
    NEEDAUTH(3),
    /// 拒绝绑定
    REFUSEDBIND(4),
    /// 绑定错误设备
    WRONGDEVICE(5),
    /// 授权码校验失败
    AUTHCODECHECKFAILED(6),
    /// 取消绑定
    CANCELED(7),
    /// 绑定失败（获取功能表失败)
    FAILEDONGETFUNCTIONTABLE(8),
    /// 绑定失败（获取设备信息失败)
    FAILEDONGETDEVICEINFO(9),
    /// 绑定超时（支持该功能的设备专用）
    TIMEOUT(10),
    /// 新账户绑定，用户确定删除设备数据（支持该功能的设备专用）
    AGREEDELETEDEVICEDATA(11),
    /// 新账户绑定，用户不删除设备数据，绑定失败（支持该功能的设备专用）
    DENYDELETEDEVICEDATA(12),
    /// 新账户绑定，用户不选择，设备超时（支持该功能的设备专用）
    TIMEOUTONNEWACCOUNT(13),
    /// 设备同意配对(绑定)请求，等待APP下发配对结果（支持该功能的设备专用）
    NEEDCONFIRMBYAPP(14);

    companion object {
        fun ofRaw(raw: Int): IDOBindStatus? {
            return IDOBindStatus.values().firstOrNull { it.raw == raw }
        }
    }
}

enum class IDONoticeMessageType(val raw: Int) {
    SMS(0X01),
    EMAIL(0X02),
    WX(0X03),
    QQ(0X04),
    WEIBO(0X05),
    FACEBOOK(0X06),
    TWITTER(0X07),
    WHATSAPP(0X08),
    MESSENGER(0X09),
    INSTAGRAM(0X0A),
    LINKEDIN(0X0B),
    CALENDAR(0X0C),
    SKYPE(0X0D),
    ALARM(0X0E),
    VKONTAKTE(0X10),
    LINE(0X11),
    VIBER(0X12),
    KAKAO_TALK(0X13),
    GMAIL(0X14),
    OUTLOOK(0X15),
    SNAPCHAT(0X16),
    TELEGRAM(0X17),
    CHATWORK(0X20),
    SLACK(0X21),
    TUMBLR(0X23),
    YOUTUBE(0X24),
    PINTEREST_YAHOO(0X25),
    TIKTOK(0X26),
    REDBUS(0X27),
    DAILYHUNT(0X28),
    HOTSTAR(0X29),
    INSHORTS(0X2A),
    PAYTM(0X2B),
    AMAZON(0X2C),
    FLIPKART(0X2D),
    PRIME(0X2E),
    NETFLIX(0X2F),
    GPAY(0X30),
    PHONPE(0X31),
    SWIGGY(0X32),
    ZOMATO(0X33),
    MAKEMYTRIP(0X34),
    JIOTV(0X35),
    KEEP(0X36);

    companion object {
        fun ofRaw(raw: Int): IDONoticeMessageType? {
            return values().firstOrNull { it.raw == raw }
        }
    }

}