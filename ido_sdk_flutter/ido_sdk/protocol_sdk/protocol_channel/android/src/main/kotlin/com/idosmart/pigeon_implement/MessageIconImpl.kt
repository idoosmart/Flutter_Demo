package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_message_icon.AppIconInfoModel
import com.idosmart.pigeongen.api_message_icon.AppIconItemModel
import com.idosmart.pigeongen.api_message_icon.MessageIcon
import com.idosmart.protocol_channel.plugin
import com.idosmart.model.*
import com.idosmart.protocol_channel.innerRunOnMainThread
import com.idosmart.protocol_sdk.MessageIconInterface

internal class MessageIconImpl: MessageIconInterface {

    private fun messageIcon(): MessageIcon? {
        return plugin.messageIcon()
    }

    override val updating: Boolean
        get() = MessageIconDelegateImpl.instance().updating
    override val iconDirPath: String
        get() = MessageIconDelegateImpl.instance().dirPath

    override fun getDefaultAppInfo(completion: (items: List<IDOAppIconItemModel>) -> Unit) {
        innerRunOnMainThread {
            messageIcon()?.getDefaultAppInfo {
                val items = mutableListOf<IDOAppIconItemModel>()
                it.forEach { element ->
                    val item = itemModelExchange(element)
                    items.add(item)
                }
                completion(items)
            }
        }
    }

    override fun firstGetAppInfo(
        force: Boolean,
        completion: (items: List<IDOAppIconItemModel>) -> Unit
    ) {
        innerRunOnMainThread {
            messageIcon()?.firstGetAllAppInfo(force) {
                val items = mutableListOf<IDOAppIconItemModel>()
                it.forEach { element ->
                    val item = itemModelExchange(element)
                    items.add(item)
                }
                completion(items)
            }
        }
    }

    override fun getCacheAppInfo(completion: (model: IDOAppIconInfoModel) -> Unit) {
        innerRunOnMainThread {
            messageIcon()?.getCacheAppInfoModel {
                val model = iconInfoExchange(it)
                completion(model)
            }
        }
    }

    override fun resetIconInfoData(
        macAddress: String,
        deleteIcon: Boolean,
        completion: (result: Boolean) -> Unit
    ) {
        innerRunOnMainThread {
            messageIcon()?.resetIconInfoData(macAddress, deleteIcon, completion)
        }
    }

    override fun androidSendMessageIconToDevice(
        eventType: Int,
        completion: (result: Boolean) -> Unit
    ) {
        innerRunOnMainThread {
            messageIcon()?.androidSendMessageIconToDevice(eventType.toLong(), completion)
        }
    }

    private fun itemModelExchange(model: AppIconItemModel?): IDOAppIconItemModel {
        val item = IDOAppIconItemModel()
        item.itemId = model?.itemId?.toInt()
        item.evtType = model?.evtType?.toInt()
        item.packName = model?.packName
        item.appName = model?.appName
        item.iconLocalPath = model?.iconLocalPath
        item.msgCount = model?.msgCount?.toInt()
        item.iconCloudPath = model?.iconCloudPath
        item.state = model?.state?.toInt()
        item.iconLocalPathBig = model?.iconLocalPathBig
        item.countryCode = model?.countryCode
        item.appVersion = model?.appVersion
        item.isDownloadAppInfo = model?.isDownloadAppInfo
        item.isUpdateAppName = model?.isUpdateAppName
        item.isUpdateAppIcon = model?.isUpdateAppIcon
        item.isDefault = model?.isDefault
        return item
    }

    private  fun iconInfoExchange(model: AppIconInfoModel): IDOAppIconInfoModel {
         val appInfo = IDOAppIconInfoModel()
         appInfo.version = model.version?.toInt()
         appInfo.iconWidth = model.iconWidth?.toInt()
         appInfo.iconHeight = model.iconHeight?.toInt()
         appInfo.colorFormat = model.colorFormat?.toInt()
         appInfo.blockSize = model.blockSize?.toInt()
         appInfo.totalNum = model.totalNum?.toInt()
         val items = mutableListOf<IDOAppIconItemModel>()
         model.items?.forEach { element->
            val item = itemModelExchange(element)
            items.add(item)
         }
         appInfo.items = items
         return appInfo
    }

}