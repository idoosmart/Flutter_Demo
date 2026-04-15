package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_cache.Cache
import com.idosmart.pigeongen.api_tools.Tool
import com.idosmart.protocol_channel.innerRunOnMainThread
import com.idosmart.protocol_channel.plugin
import com.idosmart.protocol_sdk.ToolsInterface

import kotlinx.coroutines.*

internal class ToolImpl: ToolsInterface {

    private fun tool(): Tool? {
        return plugin.tool()
    }

    private fun cache(): Cache? {
        return plugin.cache()
    }

    override fun png2Bmp(
        inPath: String,
        outPath: String,
        format: Int,
        completion: (Boolean) -> Unit
    ) {
        innerRunOnMainThread {
            tool()?.png2Bmp(inPath, outPath, format.toLong()) {
                completion(it.toInt() == 0)
            }
        }
    }

    override fun compressToPNG(
        inputFilePath: String,
        outputFilePath: String,
        completion: (Boolean) -> Unit
    ) {
        innerRunOnMainThread {
            tool()?.compressToPNG(inputFilePath, outputFilePath) {
                completion(it.toInt() == 0)
            }
        }
    }

    override fun makeEpoFile(dirPath: String, epoFilePath: String, completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            tool()?.makeEpoFile(dirPath, epoFilePath, completion)
        }
    }

    override fun mp3SamplingRate(mp3FilePath: String, completion: (Int) -> Unit) {
        innerRunOnMainThread {
            tool()?.mp3SamplingRate(mp3FilePath) {
                completion(it.toInt())
            }
        }
    }

    override fun gpsInitType(motionTypeIn: Int, completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            tool()?.gpsInitType(motionTypeIn.toLong()) {
                completion(it.toInt() == 0)
            }
        }
    }

    override fun gpsAlgProcessRealtime(json: String, completion: (String) -> Unit) {
        innerRunOnMainThread {
            tool()?.gpsAlgProcessRealtime(json, completion)
        }
    }

    override fun gpsSmoothData(json: String, completion: (String) -> Unit) {
        innerRunOnMainThread {
            tool()?.gpsSmoothData(json, completion)
        }
    }

    override fun logPath(completion: (String) -> Unit) {
        innerRunOnMainThread {
            cache()?.logPath(completion)
        }
    }

    override fun currentDevicePath(completion: (String) -> Unit) {
        innerRunOnMainThread {
            cache()?.currentDevicePath(completion)
        }
    }

    override fun exportLog(completion: (String) -> Unit) {
        innerRunOnMainThread {
            cache()?.exportLog(completion)
        }
    }

    override fun lastConnectDevice(completion: (String?) -> Unit) {
        innerRunOnMainThread {
            cache()?.lastConnectDevice {
                val result = if ((it?.length ?: 0) > 2) it else null
                completion(result)
            }
        }
    }

    override fun loadDeviceExtListByDisk(sortDesc: Boolean, completion: (List<String>) -> Unit) {
        innerRunOnMainThread {
            cache()?.loadDeviceExtListByDisk(sortDesc) {
                completion(it ?: listOf())
            }
        }
    }

}

internal fun logNative(msg: String) {
    innerRunOnMainThread {
        plugin.tool()?.logNative(msg) {}
    }
}