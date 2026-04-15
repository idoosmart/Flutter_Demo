package com.idosmart.native_channel.nordic

import com.idosmart.native_channel.pigeon_generate.api_nordic.ApiNordicHost
import com.idosmart.native_channel.nordic.zephyr.NordicZephyrDFUManager

class NordicApiHostImpl : ApiNordicHost {

    /**
     * 开始 Nordic DFU 升级 | Start Nordic DFU upgrade
     * deviceIdentifier: Android 端传 MAC 地址 | Android passes MAC address
     * filePath: 固件文件路径 | Firmware file path
     * mtu: 忽略该值 （仅用于ios）
     */
    override fun startDFU(deviceIdentifier: String, filePath: String, mtu: Long) {
        NordicToFlutterImpl.log("[Nordic DFU] startDFU mac: $deviceIdentifier, filePath: $filePath")
        NordicZephyrDFUManager.getInstance().start(filePath, deviceIdentifier)
    }

    /**
     * 停止 Nordic DFU 升级 | Stop Nordic DFU upgrade
     */
    override fun stopDFU() {
        NordicToFlutterImpl.log("[Nordic DFU] stopDFU")
        // NordicZephyrDFUManager 通过 release() 内部调用 dfuTask.cancel()
    }
}
