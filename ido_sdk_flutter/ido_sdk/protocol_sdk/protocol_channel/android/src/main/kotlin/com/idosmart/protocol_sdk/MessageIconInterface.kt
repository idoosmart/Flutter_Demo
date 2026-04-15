package com.idosmart.protocol_sdk

import com.idosmart.model.IDOAppIconInfoModel
import com.idosmart.model.IDOAppIconItemModel


interface MessageIconInterface {

    /**
     * 是否更新中
     */
    val updating: Boolean

    /**
     * 获取icon图片存放目录地
     */
    val iconDirPath: String

    /**
     * 设备支持默认APP信息集合
     * @param completion: 返回APP信息结果
     *     - items: List<IDOAppIconItemModel>
     */
    fun getDefaultAppInfo(completion: (items: List<IDOAppIconItemModel>) -> Unit)

    /**
     * android 已安装所有app信息集合
     * @param force: Android强制更新 消息图标和名字
     * @param completion: 返回APP信息结果
     *     - items: List<IDOAppIconItemModel>
     */
    fun firstGetAppInfo(force: Boolean,completion: (items: List<IDOAppIconItemModel>) -> Unit)

    /**
     * 获取缓存APP信息
     * @param completion: 返回APP信息结果
     *     - model: IDOAppIconInfoModel
     */
    fun getCacheAppInfo(completion: (model: IDOAppIconInfoModel) -> Unit)

    /**
     * 重置APP图标信息（删除本地沙盒缓存的图片）
     * @param macAddress: 需要清除数据的MAC地址
     * @param deleteIcon: 是否删除icon 图片文件，默认删除
     * @param completion: 删除状态
     *     - result: Boolean
     */
    fun resetIconInfoData(macAddress: String,deleteIcon: Boolean,completion: (result: Boolean) -> Unit)

    /**
     * Android 当有收到通知时下发消息图标到设备
     * @param eventType: 事件类型
     * @param completion: 下发状态
     *     - result: Boolean
     */
    fun androidSendMessageIconToDevice(eventType: Int,completion: (result: Boolean) -> Unit)

}