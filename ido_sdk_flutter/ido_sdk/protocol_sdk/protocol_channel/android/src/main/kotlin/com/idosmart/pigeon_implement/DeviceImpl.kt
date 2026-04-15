package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_device.DeviceInfo
import com.idosmart.protocol_channel.innerRunOnMainThread
import com.idosmart.protocol_channel.plugin
import com.idosmart.protocol_sdk.DeviceInterface

private val delegate = DeviceDelegateImpl.instance()
private val device = plugin.device()
internal class IDODevice(private var deviceInfo: DeviceInfo? = null) : DeviceInterface {

    private fun devInfo(): DeviceInfo? {
        return deviceInfo ?: delegate.deviceInfo
    }

    override fun toString(): String {
        return "IDODevice(deviceMode=$deviceMode, battStatus=$battStatus, battLevel=$battLevel, rebootFlag=$rebootFlag, bindState=$bindState, bindType=$bindType, bindTimeout=$bindTimeout, platform=$platform, deviceShapeType=$deviceShapeType, deviceType=$deviceType, dialMainVersion=$dialMainVersion, showBindChoiceUi=$showBindChoiceUi, deviceId=$deviceId, firmwareVersion=$firmwareVersion, macAddress='$macAddress', macAddressFull='$macAddressFull', deviceName='$deviceName', otaMode=$otaMode, uuid='$uuid', macAddressBt='$macAddressBt', fwVersion1=$fwVersion1, fwVersion2=$fwVersion2, fwVersion3=$fwVersion3, fwBtFlag=$fwBtFlag, fwBtVersion1=$fwBtVersion1, fwBtVersion2=$fwBtVersion2, fwBtVersion3=$fwBtVersion3, fwBtMatchVersion1=$fwBtMatchVersion1, fwBtMatchVersion2=$fwBtMatchVersion2, fwBtMatchVersion3=$fwBtMatchVersion3)"
    }

    override val deviceMode: Int
        get() = (devInfo()?.deviceMode ?: 0).toInt()


    override val battStatus: Int
        get() = (devInfo()?.battStatus ?: 0).toInt()


    override val battLevel: Int
        get() = (devInfo()?.battLevel ?: 0).toInt()


    override val rebootFlag: Int
        get() = (devInfo()?.rebootFlag ?: 0).toInt()


    override val bindState: Int
        get() = (devInfo()?.bindState ?: 0).toInt()


    override val bindType: Int
        get() = (devInfo()?.bindType ?: 0).toInt()


    override val bindTimeout: Int
        get() = (devInfo()?.bindTimeout ?: 0).toInt()


    override val platform: Int
        get() = (devInfo()?.platform ?: 0).toInt()


    override val deviceShapeType: Int
        get() = (devInfo()?.deviceShapeType ?: 0).toInt()


    override val deviceType: Int
        get() = (devInfo()?.deviceType ?: 0).toInt()


    override val dialMainVersion: Int
        get() = (devInfo()?.dialMainVersion ?: 0).toInt()


    override val showBindChoiceUi: Int
        get() = (devInfo()?.showBindChoiceUi ?: 0).toInt()


    override val deviceId: Int
        get() = (devInfo()?.deviceId ?: 0).toInt()


    override val firmwareVersion: Int
        get() = (devInfo()?.firmwareVersion ?: 0).toInt()


    override val macAddress: String
        get() = devInfo()?.macAddress ?: ""


    override val macAddressFull: String
        get() = devInfo()?.macAddressFull ?: ""


    override val deviceName: String
        get() = devInfo()?.deviceName ?: ""


    override val otaMode: Boolean
        get() = devInfo()?.otaMode ?: false


    override val uuid: String
        get() = devInfo()?.uuid ?: ""


    override val macAddressBt: String
        get() = devInfo()?.macAddressBt ?: ""
    override val sn: String?
        get() = devInfo()?.sn
    override val btName: String?
        get() = devInfo()?.btName
    override val gpsPlatform: Int
        get() = (devInfo()?.gpsPlatform ?: 0).toInt()


    override val fwVersion1: Int
        get() = (devInfo()?.fwVersion1 ?: 0).toInt()


    override val fwVersion2: Int
        get() = (devInfo()?.fwVersion2 ?: 0).toInt()


    override val fwVersion3: Int
        get() = (devInfo()?.fwVersion3 ?: 0).toInt()


    override val fwBtFlag: Int
        get() = (devInfo()?.fwBtFlag ?: 0).toInt()


    override val fwBtVersion1: Int
        get() = (devInfo()?.fwBtVersion1 ?: 0).toInt()


    override val fwBtVersion2: Int
        get() = (devInfo()?.fwBtVersion2 ?: 0).toInt()


    override val fwBtVersion3: Int
        get() = (devInfo()?.fwBtVersion3 ?: 0).toInt()


    override val fwBtMatchVersion1: Int
        get() = (devInfo()?.fwBtMatchVersion1 ?: 0).toInt()


    override val fwBtMatchVersion2: Int
        get() = (devInfo()?.fwBtMatchVersion2 ?: 0).toInt()


    override val
            fwBtMatchVersion3: Int
        get() = (devInfo()?.fwBtMatchVersion3 ?: 0).toInt()

    override fun refreshDeviceInfo(forced: Boolean, completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            device?.refreshDeviceInfo(forced, completion)
        }
    }

    override fun refreshFirmwareVersion(forced: Boolean, completion: (Boolean) -> Unit) {
        innerRunOnMainThread {
            device?.refreshFirmwareVersion(forced, completion)
        }
    }

}