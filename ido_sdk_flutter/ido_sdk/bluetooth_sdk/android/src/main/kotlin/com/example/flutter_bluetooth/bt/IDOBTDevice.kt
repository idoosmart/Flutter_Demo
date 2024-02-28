package com.example.flutter_bluetooth.bt

import com.example.flutter_bluetooth.bt.spp.ISPPConnectStateListener
import com.example.flutter_bluetooth.bt.spp.ISPPDataListener
import com.example.flutter_bluetooth.bt.spp.SPPConnector
import com.example.flutter_bluetooth.logger.Logger

/**
 * @author tianwei
 * @date 2022/12/27
 * @time 11:16
 * 用途: 抽象bt设备，隔离多设备
 */
class IDOBTDevice(deviceAddress: String?) {
    private val btPair = BTPair(deviceAddress)
    private val sppConnector = SPPConnector(deviceAddress)
    private val a2dpConnectHelper = A2dpConnectHelper(deviceAddress!!)

    /**
     * 创建BT配对
     */
    fun createPair(listener: IBondStateListener?) {
        btPair.createPair(listener)
    }

    fun getA2dpState(): Int {
        return a2dpConnectHelper.getA2dpState()
    }

    /**
     * 移除BT配对
     */
    fun removePair(): Boolean {
        Logger.p("removePair")
        return btPair.removePair()
    }

    /**
     * 连接spp
     */
    fun connectSPP(listener: ISPPConnectStateListener?) {
        sppConnector.connect(listener)
    }

    /**
     * SPP断连
     */
    fun disconnectSPP() {
        sppConnector.toDisconnect()
    }

    /**
     * 判断SPP连接状态
     */
    fun isSPPConnected(): Boolean {
        return sppConnector.isConnected
    }

    /**
     * 通过spp发送数据
     *
     * @param data
     */
    fun writeData(data: ByteArray) {
        sppConnector.addCmd(data)
    }

    fun registerA2dpStateListener(listener: A2dpConnectHelper.OnA2dpConnectChangedListener) {
        a2dpConnectHelper.onA2dpConnectChangedListener = listener
    }

    fun registerSPPDataListener(listener: ISPPDataListener?) {
        sppConnector.registerSPPDataListener(listener)
    }

    fun unregisterSPPDataListener(listener: ISPPDataListener?) {
        sppConnector.unregisterSPPDataListener()
    }
}