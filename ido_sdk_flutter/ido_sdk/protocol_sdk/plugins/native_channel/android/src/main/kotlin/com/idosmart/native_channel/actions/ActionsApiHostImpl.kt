package com.idosmart.native_channel.actions

import com.idosmart.native_channel.common.BleDFUConfig
import com.idosmart.native_channel.pigeon_generate.api_actions.ApiActionsHost

/**
 * Actions OTA Host API 实现 | Actions OTA Host API implementation
 * 参照 SicheApiHostImpl / NordicApiHostImpl
 */
class ActionsApiHostImpl : ApiActionsHost {

    /**
     * 开始 Actions OTA 升级 | Start Actions OTA upgrade
     * deviceIdentifier: Android 端传 MAC 地址
     * filePath: 固件文件路径
     */
    override fun startOTA(deviceIdentifier: String, filePath: String) {
        ActionsToFlutterImpl.log("[Actions OTA] startOTA mac: $deviceIdentifier, filePath: $filePath")
        val config = BleDFUConfig()
            .setMacAddress(deviceIdentifier)
            .setFilePath(filePath)
            .setPlatform(BleDFUConfig.PLATFORM_ACTIONS)
        ActionsDFUManager.getManager().start(config)
    }

    /** 停止 Actions OTA 升级 | Stop Actions OTA upgrade */
    override fun stopOTA() {
        ActionsToFlutterImpl.log("[Actions OTA] stopOTA")
        ActionsDFUManager.getManager().cancel()
    }
}
