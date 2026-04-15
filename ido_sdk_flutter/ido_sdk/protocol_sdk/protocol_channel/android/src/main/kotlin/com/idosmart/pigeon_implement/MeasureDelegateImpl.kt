package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_measure.MeasureDelegate
import com.idosmart.pigeongen.api_measure.MeasureResult

internal class MeasureDelegateImpl private constructor() : MeasureDelegate {
    companion object {
        @Volatile
        private var instance: MeasureDelegateImpl? = null

        fun instance(): MeasureDelegateImpl {
            return instance ?: synchronized(this) {
                instance ?: MeasureDelegateImpl().also { instance = it }
            }
        }
    }

    var callbackProcessMeasureData: ((MeasureResult) -> Unit)? = null

    override fun listenMeasureResult(result: MeasureResult) {
        callbackProcessMeasureData?.invoke(result)
    }
}
