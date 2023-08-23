package com.example.flutter_bluetooth.ble.callback

/**
 * @author tianwei
 * @date 2023/2/7
 * @time 16:29
 * 用途:自定义指令的回调
 */
interface CustomCmdResponseCallback {
    fun onResponse(byteArray: ByteArray)
}