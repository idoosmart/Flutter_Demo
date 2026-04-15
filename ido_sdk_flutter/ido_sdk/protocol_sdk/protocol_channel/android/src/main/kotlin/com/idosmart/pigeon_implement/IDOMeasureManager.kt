package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_measure.Measure
import com.idosmart.pigeongen.api_measure.MeasureResult
import com.idosmart.pigeongen.api_measure.MeasureType
import com.idosmart.pigeongen.api_measure.MeasureStatus
import com.idosmart.protocol_channel.ProtocolChannelPlugin
import com.idosmart.protocol_channel.innerRunOnMainThread

private val _measureMgr: Measure?
    get() = ProtocolChannelPlugin.instance().measure()

private val _measureImpl: MeasureDelegateImpl
    get() = MeasureDelegateImpl.instance()

open class IDOMeasureManager private constructor() {
    companion object {
        val shared: IDOMeasureManager by lazy { IDOMeasureManager() }
    }

    /**
     * 测量结果监听
     */
    fun listenProcessMeasureData(callback: (IDOMeasureResult) -> Unit) {
        _measureImpl.callbackProcessMeasureData = { result ->
            callback(IDOMeasureResult.fromPigeon(result))
        }
    }

    fun startMeasure(type: IDOMeasureType, completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            val pType = MeasureType.values().firstOrNull { it.raw == type.raw } ?: MeasureType.BLOODPRESSURE
            _measureMgr?.startMeasure(pType) {
                completion(it)
            }
        }
    }

    fun stopMeasure(type: IDOMeasureType, completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            val pType = MeasureType.values().firstOrNull { it.raw == type.raw } ?: MeasureType.BLOODPRESSURE
            _measureMgr?.stopMeasure(pType) {
                completion(it)
            }
        }
    }

    fun getMeasureData(type: IDOMeasureType, completion: (IDOMeasureResult) -> Unit) {
        innerRunOnMainThread {
            val pType = MeasureType.values().firstOrNull { it.raw == type.raw } ?: MeasureType.BLOODPRESSURE
            _measureMgr?.getMeasureData(pType) {
                completion(IDOMeasureResult.fromPigeon(it))
            }
        }
    }
}


open class IDOMeasureResult(
    var status: IDOMeasureStatus = IDOMeasureStatus.NOT_SUPPORT,
    var systolicBp: Int = 0,
    var diastolicBp: Int = 0,
    var value: Int = 0,
    var oneClickHr: Int = 0,
    var oneClickStress: Int = 0,
    var oneClickSpo2: Int = 0,
    var temperatureValue: Int = 0
) {
    companion object {
        internal fun fromPigeon(result: MeasureResult): IDOMeasureResult {
            return IDOMeasureResult(
                status = IDOMeasureStatus.values().firstOrNull { it.raw == (result.status?.raw ?: 0) } ?: IDOMeasureStatus.NOT_SUPPORT,
                systolicBp = result.systolicBp?.toInt() ?: 0,
                diastolicBp = result.diastolicBp?.toInt() ?: 0,
                value = result.value?.toInt() ?: 0,
                oneClickHr = result.oneClickHr?.toInt() ?: 0,
                oneClickStress = result.oneClickStress?.toInt() ?: 0,
                oneClickSpo2 = result.oneClickSpo2?.toInt() ?: 0,
                temperatureValue = result.temperatureValue?.toInt() ?: 0
            )
        }
    }
}

enum class IDOMeasureType(val raw: Int) {
    BLOOD_PRESSURE(0),
    HEART_RATE(1),
    SPO2(2),
    STRESS(3),
    ONE_CLICK(4),
    TEMPERATURE(5),
    BODY_COMPOSITION(6)
}

enum class IDOMeasureStatus(val raw: Int) {
    NOT_SUPPORT(0),
    MEASURING(1),
    SUCCESS(2),
    FAILED(3),
    DEVICE_IN_SPORT_MODE(4),
    MEASURING_DATA(5),
    TIMEOUT(6),
    STOPPED(7),
    DISCONNECTED(8),
    UNWORN(9)
}
