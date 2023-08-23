package com.example.flutter_bluetooth.dfu

/**
 * Created by Zhouzj on 2017/12/26.
 *
 */
object BleDFUConstants {
    const val LOG_TAG = "IDO_BLE_DFU"
    const val LOG_TAG_NODIC = "IDO_BLE_DFU"
    const val LOG_TAG_RTK = "IDO_BLE_DFU_RTK"


    object Cmd {
        val ENTER_DFU_MODE = byteArrayOf(0x01, 0x01)
    }
}