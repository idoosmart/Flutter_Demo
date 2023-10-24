package com.idosmart.alexa.callbacks

import com.idosmart.pigeon.api_channel.ApiAlexaError


/**
 * @author tianwei
 * @date 2023/9/23
 * @time 17:37
 * 用途:
 */
interface DownStreamResultCallback {
    fun onDownStreamError(error: ApiAlexaError)

    fun onDownStreamData(bytes: ByteArray)
}