//
//  IDOMessageIconInterface.swift
//  alexa_channel
//
//  Created by hc on 2023/11/2.
//

import Foundation

/// 消息图标
@objc
public protocol IDOMessageIconInterface {

    /// 是否更新中
    var updating: Bool { get }

        /// 获取icon图片存放目录地
    var iconDirPath: String { get }
    
    /// ios 配置
    /// countryCode：国家编码
    /// baseUrlPath：base url 缓存服务器地址
    /// appKey：后台请求分配 appKey
    /// language：语言单位
    @available(*, deprecated, message: "This method is deprecated and will be removed in a future version. Use config(...)")
    func iOSConfig(countryCode: String, baseUrlPath: String, appKey: String, language: Int)
    
    /// ios 配置
    /// countryCode：国家编码
    /// baseUrlPath：base url 缓存服务器地址
    /// appKey：后台请求分配 appKey
    /// language：语言单位 无效:0,中文:1,英文:2,法语:3,德语:4,意大利语:5,西班牙语:6,日语:7,
    /// 波兰语:8,捷克语:9,罗马尼亚:10,立陶宛语:11,荷兰语:12,斯洛文尼亚:13,
    /// 匈牙利语:14,俄罗斯语:15,乌克兰语:16,斯洛伐克语:17,丹麦语:18,克罗地亚:19,印尼语:20,
    /// 韩语:21,印地语:22,葡萄牙语:23,土耳其:24,泰国语:25,越南语:26,缅甸语:27,
    /// 菲律宾语:28,繁体中文:29,希腊语:30,阿拉伯语:31,瑞典语:32,芬兰语:33,波斯语:34,挪威语:35
    /// 未设语言单位，默认为英文
    func config(countryCode: String?, baseUrlPath: String?, appKey: String?, language: NSNumber?)
    
    /// ios 需要执行获取默认的APP包名列表信息，因为event_type是固件分配的 force 强制更新应用名称
    func firstGetAppInfo(force: Bool, completion: @escaping ([IDOAppIconItemModel]) -> Void)

    /// 设置默认app信息集合(仅限支持的设备使用)
    func setDefaultAppInfoList(list: [IDOAppIconItemModel], completion: @escaping (Bool) -> Void);
    
    /// 设备支持默认app信息集合
    /// ios 只有默认的包名
    /// android 会包含默认的event_type 如果已经安装的应用则包含图标地址
    func getDefaultAppInfo(completion: @escaping ([IDOAppIconItemModel]) -> Void)

    /// 获取缓存的app信息数据
    /// 如果有动态更新app图标则会缓存数据，获取数据显示到开关控制列表
    func getCacheAppInfo(completion: @escaping (IDOAppIconInfoModel) -> Void)

    /// 重置APP图标信息（删除本地沙盒缓存的图片）
    /// macAddress 需要清除数据的MAC地址
    /// deleteIcon 是否删除icon 图片文件，默认删除
    func resetIconInfoData(macAddress: String, deleteIcon: Bool, completion: @escaping (Bool) -> Void)

}
