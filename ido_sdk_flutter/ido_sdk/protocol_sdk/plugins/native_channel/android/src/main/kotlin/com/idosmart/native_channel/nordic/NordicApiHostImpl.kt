package com.idosmart.native_channel.nordic

import com.idosmart.native_channel.nordic.zephyr.NordicZephyrDFUManager
import com.idosmart.native_channel.pigeon_generate.api_nordic.ApiNordicHost
import com.idosmart.native_channel.pigeon_generate.api_nordic.NordicDFUState

class NordicApiHostImpl : ApiNordicHost {

    companion object {
        /**
         * mcumgr-ble 1.x 代表性类名。
         * Native AAR 打包态对该依赖为 compileOnly：App 未声明时不得加载 NordicZephyrDFU*
         * （其继承/实现会触发 NoClassDefFoundError）。
         * Flutter path 默认随库 implementation，探测通常为 true。
         * 3.x 起包名改为 no.nordicsemi.android.mcumgr，与本探测不兼容。
         */
        private const val MCU_MGR_BLE_TRANSPORT_CLASS =
            "io.runtime.mcumgr.ble.McuMgrBleTransport"

        private const val MISSING_MCU_MGR_ERROR =
            "Missing dependency no.nordicsemi.android:mcumgr-ble:1.5.2 " +
                "(package io.runtime.mcumgr). Add it to the app build.gradle when " +
                "using Nordic Zephyr / MCUmgr DFU. mcumgr-ble 3.x uses a different " +
                "package name and is not compatible with this SDK path."
    }

    /**
     * 开始 Nordic DFU 升级 | Start Nordic DFU upgrade
     * deviceIdentifier: Android 端传 MAC 地址 | Android passes MAC address
     * filePath: 固件文件路径 | Firmware file path
     * mtu: 忽略该值 （仅用于ios）
     */
    override fun startDFU(deviceIdentifier: String, filePath: String, mtu: Long) {
        NordicToFlutterImpl.log("[Nordic DFU] startDFU mac: $deviceIdentifier, filePath: $filePath")
        if (!isMcuMgrBleAvailable()) {
            NordicToFlutterImpl.log("[Nordic DFU] $MISSING_MCU_MGR_ERROR")
            NordicToFlutterImpl.onDFUStateChanged(NordicDFUState.FAILED, MISSING_MCU_MGR_ERROR)
            return
        }
        NordicZephyrDFUManager.getInstance().start(filePath, deviceIdentifier)
    }

    /**
     * 停止 Nordic DFU 升级 | Stop Nordic DFU upgrade
     */
    override fun stopDFU() {
        NordicToFlutterImpl.log("[Nordic DFU] stopDFU")
        // NordicZephyrDFUManager 通过 release() 内部调用 dfuTask.cancel()
    }

    /**
     * 探测是否提供了与本 SDK 兼容的 mcumgr-ble（1.x / io.runtime.mcumgr）。
     * Native AAR（compileOnly）场景下须在引用任何 NordicZephyrDFU* 之前调用。
     */
    private fun isMcuMgrBleAvailable(): Boolean {
        return try {
            Class.forName(MCU_MGR_BLE_TRANSPORT_CLASS)
            true
        } catch (_: ClassNotFoundException) {
            false
        } catch (_: NoClassDefFoundError) {
            // 部分链路下父类缺失会抛 NoClassDefFoundError 而非 ClassNotFoundException
            false
        }
    }
}
