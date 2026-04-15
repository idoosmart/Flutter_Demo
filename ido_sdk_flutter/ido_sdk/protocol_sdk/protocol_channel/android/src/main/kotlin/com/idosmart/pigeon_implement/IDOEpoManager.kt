package com.idosmart.pigeon_implement

// IDOEpoManager.kt
// protocol_channel
// Created by hc on 2024/8/8

import com.idosmart.pigeongen.api_epo.ApiEPOManager
import com.idosmart.protocol_channel.ProtocolChannelPlugin
import com.idosmart.protocol_channel.innerRunOnMainThread
import com.idosmart.protocol_channel.sdk
import com.idosmart.pigeon_implement.EpoManagerDelegateImpl

private val _epoMgr: ApiEPOManager?
    get() =  ProtocolChannelPlugin.instance().epo()

private val _epoImpl: EpoManagerDelegateImpl
    get() = EpoManagerDelegateImpl.instance()

open class IDOEpoManager private constructor() {
    companion object {
        val shared: IDOEpoManager by lazy { IDOEpoManager() }
    }


    // 启用自动epo升级，默认为 关
    //
    // 触发条件：
    // 1、每次快速配置完成后倒计时1分钟；
    // 2、数据同步完成后立即执行；
    var enableAutoUpgrade: Boolean = false
        set(value) {
            field = value
            innerRunOnMainThread {
                _epoMgr?.setEnableAutoUpgrade(enableAutoUpgrade) { }
            }
        }


    // Current upgrade status
    val status: IDOEpoUpgradeStatus
        get() = _epoImpl.upgradeStatus

    // Whether EPO upgrade is supported
    val isSupported: Boolean
        get() {
            val ft = sdk.funcTable
            return (ft.setAirohaGpsChip && (ft.syncGps || ft.syncV3Gps)) || sdk.device.gpsPlatform == 3
        }

    // App provides current phone GPS information for quick device location
    var delegateGetGps: IDOEpoManagerDelegate? = null
        set(value) {
            field = value
            _epoImpl.delegateGps = value
        }

    // Get the timestamp of the last update in millisecond
    // Returns 0 if there is no record
    fun lastUpdateTimestamp(completion: (Long) -> Unit) {
        innerRunOnMainThread {
            _epoMgr?.lastUpdateTimestamp {
                completion(it)
            }
        }
    }

    // Whether an update is needed
    fun shouldUpdateForEPO(isForce: Boolean = false, completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            _epoMgr?.shouldUpdateForEPO(isForce, completion)
        }
    }

    // Start upgrade task
    // - Parameters:
    //   - isForce: Whether to force update, default is false
    //   - retryCount: Number of retries, default is 3 times
    fun willStartInstall(isForce: Boolean = false, retryCount: Int = 3) {
        innerRunOnMainThread {
            _epoMgr?.willStartInstall(isForce, retryCount.toLong()) {}
        }
    }

    // Stop upgrade task
    // Note: Only supports tasks that are downloading or sending, not tasks that are upgrading
    fun stop() {
        innerRunOnMainThread {
            _epoMgr?.stop {}
        }
    }

    // Listen for EPO upgrade callback (global listen once)
    // - Parameters:
    //  - funcStatus: Upgrade status
    //  - downProgress: Download progress
    //  - sendProgress: Send progress
    //  - funcComplete: Upgrade complete, errorCode: 0 success, non-0 failure
    fun listenEpoUpgrade(
        funcStatus: (IDOEpoUpgradeStatus) -> Unit,
        downProgress: ((Float) -> Unit)? = null,
        sendProgress: ((Float) -> Unit)? = null,
        funcComplete: (Int) -> Unit
    ) {
        val epoImpl = EpoManagerDelegateImpl.instance()
        epoImpl.callbackUpgradeStatus = funcStatus
        epoImpl.callbackDownProgress = downProgress
        epoImpl.callbackSendProgress = sendProgress
        epoImpl.callbackComplete = funcComplete
    }
}

open interface IDOEpoManagerDelegate {
    // Provide current phone GPS information to speed up device positioning (only for supported devices)
    fun getAppGpsInfo(): IDOOtaGpsInfo?
}

open class IDOOtaGpsInfo(
    // Longitude
    var longitude: Float,
    // Latitude
    var latitude: Float,
    // Altitude
    var altitude: Float
)

enum class IDOEpoUpgradeStatus(val value: Int) {
    // Idle
    IDLE(0),
    // Ready to update
    READY(1),
    // Downloading
    DOWNING(2),
    // Making
    MAKING(3),
    // Sending
    SENDING(4),
    // Installing
    INSTALLING(5),
    // Success
    SUCCESS(6),
    // Failure
    FAILURE(7);
    companion object {
        fun ofRaw(value: Int): IDOEpoUpgradeStatus? {
            return IDOEpoUpgradeStatus.values().firstOrNull { it.value == value }
        }
    }
}