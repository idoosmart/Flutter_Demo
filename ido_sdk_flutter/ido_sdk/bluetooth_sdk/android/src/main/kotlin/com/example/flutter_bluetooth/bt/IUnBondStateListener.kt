package com.example.flutter_bluetooth.bt

/**
 * @author tianwei
 * @date 2022/10/21
 * @time 9:31
 * 用途:解除绑定回调
 */
interface IUnBondStateListener {
    fun onUnBonded(macAddress: String)
}