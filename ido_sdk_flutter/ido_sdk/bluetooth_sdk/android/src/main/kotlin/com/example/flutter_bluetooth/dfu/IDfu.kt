package com.example.flutter_bluetooth.dfu

import com.example.flutter_bluetooth.ble.callback.ConnectCallBack
import com.example.flutter_bluetooth.ble.callback.EnterDfuModeCallback

/**
 * @author tianwei
 * @date 2023/2/7
 * @time 16:07
 * 用途: 统一DFU功能
 */
interface IDfu {
    /**
     * 开始dfu升级
     */
    fun startDFU(config: BleDFUConfig, listener: BleDFUState.IListener): Boolean

    /**
     * 取消dfu升级
     */
    fun cancelDFU()

    /**
     * 是否正在dfu升级
     */
    fun isInDFU(): Boolean

//    /**
//     * 进入dfu模式，发送01 01
//     */
//    fun enterDfuMode(callback: EnterDfuModeCallback.ICallBack?)
//
//    /**
//     * 取消进入dfu模式
//     */
//    fun cancelEnterDfuMode()
//
//    /**
//     * dfu连接
//     */
//    fun dfuConnect(callBack: ConnectCallBack?)
//
//    /**
//     * 取消dfu连接
//     */
//    fun cancelDufConnect()
//
//    /**
//     * 断连
//     */
//    fun disConnect(callBack: ConnectCallBack?)
//
//    /**
//     * 取消断连
//     */
//    fun cancelDisconnect()
}