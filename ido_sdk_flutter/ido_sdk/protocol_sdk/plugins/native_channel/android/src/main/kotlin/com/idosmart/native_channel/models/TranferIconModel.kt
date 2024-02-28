package com.idosmart.native_channel.models

class NotificationGroup {
    companion object {
        const val DEFAULT = 1 //短信、日历、邮件、未接来电、事项提醒（iOS）, 作为第一分类；
        const val BASIC = 2 //默认清单中除“短信、日历、邮件、未接来电、事项提醒（iOS）”以外的，放在第二分类；
        const val THIRD_PARTY = 3//其他动态获取的应用，放在第三分类。
    }
}

class TranferIconModel {

    //通知类型
    var type = 0

    //app包名
    var pkgName: String = ""

    //app更新时间
    var appUpdateTime: Long = 0

    //app名字
    var appName: String = ""

    var mIconFilePath = ""

    var mFileSuffix: String? = null

    //运动类型 对应的图标类型 0：这个字段无效； 1：运动小图标； 2:运动大图标； 3：运动动效图标
    var mSportType = 0

    //运动类型 对应的图标类型 0：这个字段无效； 1：运动小图标； 2:运动大图标
    var mSportSizeType = 0

    var mPicNum = 0

    //默认都是已安装的
    var mIsInstalled = true
    /**
     * 1、短信、日历、邮件、未接来电、事项提醒（iOS）, 作为第一分类；
     * 2、默认清单中除“短信、日历、邮件、未接来电、事项提醒（iOS）”以外的，放在第二分类；
     * 3、其他动态获取的应用，放在第三分类。
     */
    var group = 0
    override fun toString(): String {
        return "TranferIconModel(type=$type, pkgName='$pkgName', " +
                "appUpdateTime=$appUpdateTime, appName='$appName'," +
                " mIconFilePath='$mIconFilePath', mFileSuffix=$mFileSuffix," +
                " mSportType=$mSportType, mSportSizeType=$mSportSizeType," +
                " mPicNum=$mPicNum, mIsInstalled=$mIsInstalled, group=$group)"
    }

}