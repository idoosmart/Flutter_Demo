package com.example.flutter_bluetooth.bt.spp

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.util.Log
import com.example.flutter_bluetooth.ble.config.UUIDConfig
import com.example.flutter_bluetooth.bt.BTDeviceScanManager
import com.example.flutter_bluetooth.bt.IBTScanListener
import com.example.flutter_bluetooth.utils.ByteDataConvertUtil
import com.example.flutter_bluetooth.logger.Logger.e
import com.example.flutter_bluetooth.logger.Logger.p
import java.io.DataInputStream
import java.io.IOException
import java.util.concurrent.ConcurrentLinkedQueue
import java.util.concurrent.Executor
import java.util.concurrent.Executors
import java.util.concurrent.locks.Lock
import java.util.concurrent.locks.ReentrantLock

open class SPPConnector(val deviceAddress: String?) {
    private var socket: BluetoothSocket? = null
    private var connectStateListener: ISPPConnectStateListener? = null
    private var isRead = true
    private val EXECUTOR: Executor = Executors.newCachedThreadPool()
    private var dataInputStream: DataInputStream? = null
    private var sppDataListener: ISPPDataListener? = null
    fun registerSPPDataListener(listener: ISPPDataListener?) {
        sppDataListener = listener
    }

    fun unregisterSPPDataListener() {
        sppDataListener = null
    }

    fun connect(listener: ISPPConnectStateListener?) {
        p("[SPPConnector] connect $deviceAddress")
        if (deviceAddress.isNullOrEmpty()) {
            p("[SPPConnector] deviceAddress is empty!")
            return
        }
        isRead = false
        connectStateListener = listener
        if (connectStateListener != null) {
            connectStateListener!!.onStart(deviceAddress)
        }
        if (!BluetoothAdapter.getDefaultAdapter().isEnabled) {
            p("[SPPConnector] connect, bluetooth is disEnable ")
            failed()
            return
        }
        if (isConnected) {
            p("[SPPConnector] already connected!")
            connectStateListener?.onSuccess(deviceAddress)
            return
        }
        scanDevice(deviceAddress)
    }

    val isConnected: Boolean
        get() = socket != null && socket!!.isConnected

    private fun scanDevice(macAddress: String) {
        BTDeviceScanManager.getManager().startScan(object : IBTScanListener {
            override fun onFind(device: BluetoothDevice) {
                EXECUTOR.execute { connect(device) }
            }

            override fun onNotFind() {
                failed()
            }
        }, macAddress)
    }

    @SuppressLint("MissingPermission")
    private fun connect(device: BluetoothDevice) {
        p("[SPPConnector] connect " + device.name)
        try {
            val socket = device.createRfcommSocketToServiceRecord(UUIDConfig.SPP_UUID) //加密传输，Android系统强制配对，弹窗显示配对码
            e("[SPPConnector] createRfcommSocketToServiceRecord: ${socket?.isConnected}")
            if (!socket.isConnected) {
                socket.connect()
            }
            success(socket)
        } catch (e: IOException) {
            e("[SPPConnector] connect. " + e.message)
            failed()
        }
    }

    private fun success(socket: BluetoothSocket) {
        p("[SPPConnector] success.")
        this.socket = socket
        if (connectStateListener != null) {
            connectStateListener!!.onSuccess(deviceAddress)
        }
        EXECUTOR.execute { startReadThread(socket) }
        EXECUTOR.execute { startWriteThread(socket) }
    }

    private fun failed() {
        e("[SPPConnector] failed.")
        if (connectStateListener != null) {
            connectStateListener!!.onFailed(deviceAddress)
        }
        release()
    }

    private fun startReadThread(socket: BluetoothSocket) {
        p("[SPPConnector] startReadThread. max receiver size =" + socket.maxReceivePacketSize)
        isRead = true
        while (isRead) {
            try {
                dataInputStream = DataInputStream(socket.inputStream)
                val b = ByteArray(4 * 1024)
                var len = 0
                while (dataInputStream!!.read(b).also { len = it } != -1) {
                    receiverData(b, len)
                }
            } catch (e: IOException) {
                p("[SPPConnector] startReadThread. " + e.message)
                onBreak()
            }
        }
        p("[SPPConnector] exit read thread.")
    }

    private fun receiverData(data: ByteArray, len: Int) {
        if (sppDataListener != null) {
            val temp = ByteArray(len)
            System.arraycopy(data, 0, temp, 0, len)
            p("[SPPConnector] receive <= " + ByteDataConvertUtil.bytesToHexString(temp))
            sppDataListener!!.onSPPReceive(temp, deviceAddress)
        }
    }

    private var isWriting = true
    private val mCmdQueue = ConcurrentLinkedQueue<ByteArray>()
    private val mLock: Lock = ReentrantLock()
    private val mCondition = mLock.newCondition()
    private fun startWriteThread(socket: BluetoothSocket) {
        p("[SPPConnector] startWriteThread. max send size =" + socket.maxTransmitPacketSize)
        isWriting = true
        while (true) {
            mLock.lock()
            var bytesCmd: ByteArray? = null
            try {
                if (mCmdQueue.isEmpty()) {
                    mCondition.await()
                }
                if (!isWriting) {
                    break
                }
                bytesCmd = mCmdQueue.poll()
                write(bytesCmd)
            } catch (e: InterruptedException) {
                Log.e(TAG, e.message, e)
            } finally {
                mLock.unlock()
            }
        }
        p("[SPPConnector] exit write thread. ")
    }

    private fun write(data: ByteArray?): Boolean {
        if (data == null) {
            return false
        }
        p("[SPPConnector] send[" + data.size + "] => " + ByteDataConvertUtil.bytesToHexString(data))
        if (!isConnected) {
            e("[SPPConnector] write(). not connected.")
            return false
        }
        try {
            socket!!.outputStream.write(data)
            //与设备通信，是按包发送，所以这里强制刷新，防止粘包（多条命令合在一起发给设备了，导致设备无法解析数据）
            socket!!.outputStream.flush()
            if (sppDataListener != null) {
                sppDataListener!!.onSPPSendOneDataComplete(deviceAddress)
            }
            return true
        } catch (e: IOException) {
            e("[SPPConnector] write() " + e.message)
        }
        return false
    }

    fun addCmd(data: ByteArray) {
        mLock.lock()
        mCmdQueue.add(data)
        mCondition.signal()
        mLock.unlock()
    }

    private fun onBreak() {
        e("[SPPConnector] onBreak. ")
        if (connectStateListener != null) {
            connectStateListener!!.onBreak(deviceAddress)
        }
        release()
    }

    fun toDisconnect() {
        p("[SPPConnector] toDisconnect. ")
        if (socket != null) {
            try {
                socket!!.close()
            } catch (e: IOException) {
                e("[SPPConnector] disconnect. " + e.message)
            }
        } else {
            p("[SPPConnector] not connected!")
        }
    }

    private fun release() {
        p("[SPPConnector] release. ")
        if (dataInputStream != null) {
            try {
                dataInputStream!!.close()
            } catch (e: IOException) {
            }
        }
        mCmdQueue.clear()
        isWriting = false
        dataInputStream = null
        isRead = false
        try {
            socket?.close()
        } catch (e: IOException) {
        }
        socket = null
        connectStateListener = null
        mLock.lock()
        mCondition.signal()
        mLock.unlock()
    }

    companion object {
        private const val TAG = "SPPManager"
    }
}