package com.idosmart.model

import com.google.gson.annotations.SerializedName

class IDOAppIconItemModel {
    /// 事件类型
    @SerializedName("evt_type")
    var evtType: Int? = 0

    /// 应用包名
    @SerializedName("pack_name")
    var packName: String? = ""

    /// 应用名称
    @SerializedName("app_name")
    var appName: String? = ""

    /// icon 沙盒小图标地址 (设备使用)
    @SerializedName("icon_local_path")
    var iconLocalPath: String? = ""

    /// 每个包名给一个id 由0开始
    @SerializedName("item_id")
    var itemId: Int? = 0

    /// 消息收到次数
    @SerializedName("msg_count")
    var msgCount: Int? = 0

    /// icon 云端地址
    @SerializedName("icon_cloud_path")
    var iconCloudPath: String? = ""

    /// 消息图标更新状态
    /// 0：不需要更新 1：需要更新icon ，2：需要更新app名，3：icon和app都需要更新
    @SerializedName("state")
    var state: Int? = 0

    /// icon 沙盒大图标地址 (app 列表上展示)
    @SerializedName("icon_local_path_big")
    var iconLocalPathBig: String? = ""

    /// 国家编码
    @SerializedName("country_code")
    var countryCode: String? = ""

    /// 应用版本号
    @SerializedName("app_version")
    var appVersion: String? = ""

    /// 是否已经下载APP信息
    @SerializedName("is_download_app_info")
    var isDownloadAppInfo: Boolean? = false

    /// 是否已经更新应用名称
    @SerializedName("is_update_app_name")
    var isUpdateAppName: Boolean? = false

    /// 是否已经更新应用图标
    @SerializedName("is_update_app_icon")
    var isUpdateAppIcon: Boolean? = false

    /// 是否为默认应用
    @SerializedName("is_default")
    var isDefault: Boolean? = false
}

class IDOAppIconInfoModel {
    /// 版本号
    @SerializedName("version")
    internal var version: Int? = 0

    /// icon宽度
    @SerializedName("icon_width")
    var iconWidth: Int? = 0

    /// icon高度
    @SerializedName("icon_height")
    var iconHeight: Int? = 0

    /// 颜色格式
    @SerializedName("color_format")
    var colorFormat: Int? = 0

    /// 压缩块大小
    @SerializedName("block_size")
    var blockSize: Int? = 0

    /// 总个数
    @SerializedName("total_num")
    var totalNum: Int? = 0

    /// 包名详情集合
    @SerializedName("item")
    var items: List<IDOAppIconItemModel>? = listOf()
}