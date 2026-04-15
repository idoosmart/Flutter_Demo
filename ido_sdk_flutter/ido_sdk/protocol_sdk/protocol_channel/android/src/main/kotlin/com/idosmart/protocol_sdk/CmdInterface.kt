package com.idosmart.protocol_sdk

import com.idosmart.enums.IDOBindStatus
import com.idosmart.enums.IDONoticeMessageType
import com.idosmart.model.IDORawDataSensorInfoReply
import com.idosmart.pigeon_implement.AnyCmd
import com.idosmart.pigeon_implement.CmdResponse

 interface IDOCancellable {
    var isCancelled : Boolean
    fun cancel()
}

interface CmdProtocol<T> {
  fun send(completion: (CmdResponse<T>) -> Unit): IDOCancellable
}

// priority 优先级 0: low， 1: normal， 2: high，3： veryHigh. default 1 (不要修改值）
/// 指令优先级
enum class IDOCmdPriority(val value: Int) {
    /// 很高
    VERY_HIGH(3),
    /// 高
    HIGH(2),
    /// 正常
    NORMAL(1),
    /// 低
    LOW(0)
}

interface CmdInterface {

    /**
     * 是否在绑定中 (绑定中，切换设备将受到限制）| Whether it is in the binding (in the binding, switching devices will be restricted)
     */
    val isBinding: Boolean

    /**
     * 基础指令 | Base command
     */
    fun <T> make(anyCmd: AnyCmd<T>): AnyCmd<T>

    /**
     * 绑定设备 | Bind device
     *
     * @param osVersion: 系统版本 (取主版本号) | system version (take the major version number)
     * @param onDeviceInfo: 设备信息回调 | device information callback
     * @param onFuncTable: 功能表回调 | function table callback
     * @param completion: 绑定结果 | binding result
     * */
    fun bind(osVersion: Int,
    onDeviceInfo: ((DeviceInterface) -> Unit)?,
    onFuncTable: ((FuncTableInterface) -> Unit)?,
    completion: (IDOBindStatus) -> Unit)

    /**
    * 取消绑定（设备绑定确认前有效，仅限支持设备可用）
    */
    fun cancelBind()

    /**
     * APP下发绑定结果（仅限需要app确认绑定结果的设备使用）
     * 唯一使用场景：bind(...)方法返回IDOBindStatus.NEEDCONFIRMBYAPP时调用
     */
    fun appMarkBindResult(success: Boolean)


    /**
     * 发起解绑
     *
     * @param macAddress 设备Mac地址
     * @param isForceRemove 强制删除设备,设备无响应也删除
     */
    fun unbind(macAddress: String,
               isForceRemove: Boolean,
               completion: (Boolean) -> Unit)

    /**
     * 发送授权配对码
     *
     * @param code 配对码
     * @param osVersion 系统版本 (取主版本号)
     */
    fun setAuthCode(code: String,
                    osVersion: Int,
                    completion: (Boolean) -> Unit)

    /**
     * v2发送来电提醒以及来电电话号码和来电联系人(部分设备实现)
     *
     * @param contactText 联系人名称
     * @param phoneNumber 号码
     * @return 是否成功
     */
    fun setV2CallEvt(contactText: String,
                     phoneNumber: String,
                     completion: (Boolean) -> Unit)

    /**
     * v2发送信息提醒以及信息内容(部分设备实现)
     *
     * @param type 信息类型
     * @param contactText 通知内容
     * @param phoneNumber 号码
     * @param dataText 消息内容
     * @return 是否成功
     */
    fun setV2NoticeEvt(type: IDONoticeMessageType,
                       contactText: String,
                       phoneNumber: String,
                       dataText: String,
                       completion: (Boolean) -> Unit)

    /**
     * v2发送来电提醒状态为来电已接, 告诉设备停止提醒用户(部分设备实现)
     *
     * @return 是否成功
     */
    fun stopV2CallEvt(completion: (Boolean) -> Unit)

    /**
     * v2发送来电提醒状态为来电已拒, 告诉设备停止提醒用户(部分设备实现)
     *
     * @return 是否成功
     */
    fun missedV2MissedCallEvt(completion: (Boolean) -> Unit)

    /**
     * 监听算法原始数据采集（全局监听一次）
     */
    fun listenReceiveAlgorithmRawData(rawDataReply: (IDORawDataSensorInfoReply) -> Unit)
}