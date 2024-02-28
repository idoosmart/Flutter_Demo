package com.idosmart.native_channel.alexa.callbacks

import com.idosmart.native_channel.pigeon_generate.api_alexa.ApiAlexaError


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