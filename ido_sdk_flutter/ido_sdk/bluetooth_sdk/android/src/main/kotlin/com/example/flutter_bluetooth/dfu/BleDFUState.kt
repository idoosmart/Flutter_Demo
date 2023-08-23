package com.example.flutter_bluetooth.dfu

/**
 * Created by Zhouzj on 2017/12/22.
 * 升级状态
 */
class BleDFUState {
    companion object {
        //一切准备就绪，开始进入dfu升级流程
        const val PREPARE = 0

        //设备成功进入dfu模式
        const val DEVICE_ENTER_DFU_MODE = 1

        //进度
        const val PROGRESS = 2

        //升级完成，并已检测到手环已重启并处于正常状态
        const val SUCCESS = 3

        //升级完成，但无法检测手环处于什么状态，这个时候，你需提示用户“如果手环未重启，请重启手机蓝牙，重启app再尝试升级”
        const val SUCCESS_BUT_UNKNOWN = 4

        //升级失败，具体原因参考FailReason
        const val FAILED = 5

        //取消了升级，设备取消或主动调用取消
        const val CANCEL = 6

        //重试中，会返回当前重试次数
        const val RETRY = 7

        fun getStateDesc(state: Int): String {
            return when (state) {
                PREPARE -> "PREPARE"
                DEVICE_ENTER_DFU_MODE -> "DEVICE_ENTER_DFU_MODE"
                PROGRESS -> "PROGRESS"
                SUCCESS -> "SUCCESS"
                SUCCESS_BUT_UNKNOWN -> "SUCCESS_BUT_UNKNOWN"
                FAILED -> "FAILED"
                CANCEL -> "CANCEL"
                RETRY -> "RETRY"
                else -> ""
            }
        }

        fun getReasonDesc(error: Int): String {
            return when (error) {
                FailReason.ENTER_DFU_MODE_FAILED.ordinal -> "ENTER_DFU_MODE_FAILED"
                FailReason.DEVICE_IN_LOW_BATTERY.ordinal -> "DEVICE_IN_LOW_BATTERY"
                FailReason.NOT_FIND_TARGET_DEVICE.ordinal -> "NOT_FIND_TARGET_DEVICE"
                FailReason.CONFIG_PARAS_ERROR.ordinal -> "CONFIG_PARAS_ERROR"
                FailReason.FILE_ERROR.ordinal -> "FILE_ERROR"
                FailReason.PHONE_BLUETOOTH_ERROR.ordinal -> "PHONE_BLUETOOTH_ERROR"
                FailReason.DEVICE_NOT_REBOOT.ordinal -> "DEVICE_NOT_REBOOT"
                FailReason.OTHER.ordinal -> "OTHER"
                FailReason.OPERATION_FAILED.ordinal -> "OPERATION_FAILED"
                FailReason.OPERATION_NOT_PERMITTED.ordinal -> "OPERATION_NOT_PERMITTED"
                else -> ""
            }
        }

        fun dfuStatusDescription(status: DfuStatus?): String {
            return when (status) {
                DfuStatus.connecting -> "Connecting"
                DfuStatus.starting -> "Starting"
                DfuStatus.enablingDfuMode -> "Enabling DFU Mode"
                DfuStatus.uploading -> "Uploading"
                DfuStatus.validating -> "Validating"  // this state occurs only in Legacy DFU
                DfuStatus.disconnecting -> "Disconnecting"
                DfuStatus.completed -> "Completed"
                DfuStatus.aborted -> "Aborted"
                else -> ""
            }
        }
    }

    interface IListener {
        fun onDfuPrepare(deviceAddress: String)
        fun onDfuModeEnter(deviceAddress: String)
        fun onDfuProgress(progress: Int, deviceAddress: String)

        /**
         * 升级完成，并已检测到手环已重启并处于正常状态
         * <br></br>
         * The upgrade is completed and the device has been reboot and is in a normal state.
         */
        fun onDfuSuccess(deviceAddress: String)

        /**
         * 升级完成，但无法检测手环处于什么状态，这个时候，你需提示用户“如果手环未重启，请重启手机蓝牙，重启app再尝试升级”
         * <br></br>
         * The upgrade is completed, but it cannot detect the state of the device. At this time,
         * you need to prompt the user "if the device is not reboot, please restart phone's bluetooth,
         * or restart app and try to upgrade"
         */
        fun onDfuSuccessAndNeedToPromptUser(deviceAddress: String)
        fun onDfuFailed(failReason: FailReason?, deviceAddress: String)
        fun onDfuCanceled(deviceAddress: String)
        fun onDfuRetry(count: Int, deviceAddress: String)

        fun onDfuStatusChanged(state: DfuStatus, deviceAddress: String)
    }

    enum class DfuStatus {
        connecting, starting, enablingDfuMode, uploading, validating, disconnecting, completed, aborted,
    }

    enum class FailReason {
        /**
         * 手环无法进入升级模式
         * <br></br>
         * the device can't enter dfu mode;
         */
        ENTER_DFU_MODE_FAILED,

        /**
         * 设备低电量，无法进入升级模式
         */
        DEVICE_IN_LOW_BATTERY,

        /**
         * 无法找到设备
         * <br></br>
         * can't find device;
         */
        NOT_FIND_TARGET_DEVICE,

        /**
         * 升级配置参数错误
         * <br></br>
         * the config of dfu is error;
         */
        CONFIG_PARAS_ERROR,

        /**
         * 升级包错误
         * <br></br>
         * the device firmware file is error;
         */
        FILE_ERROR,

        /**
         * 手机系统蓝牙错误
         * <br></br>
         * the phone's bluetooth is error;
         */
        PHONE_BLUETOOTH_ERROR,

        /**
         * After the upgrade, the device did not restart
         * <br></br>
         * device not reboot
         */
        DEVICE_NOT_REBOOT,

        /**
         * 其他错误
         * <br></br>
         * other errors
         */
        OTHER,

        /**
         * 固件错误（设备ID、版本号不匹配）
         */
        OPERATION_FAILED,

        /**
         * 断点续传异常，必须要用另一个包升级了
         */
        OPERATION_NOT_PERMITTED;
    }
}