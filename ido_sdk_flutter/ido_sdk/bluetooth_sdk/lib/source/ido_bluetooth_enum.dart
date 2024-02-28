
enum IDOBluetoothSwitchType{
  off(0,false),
  on(1,true);

  final int number;
  final bool state;
  const IDOBluetoothSwitchType(this.number,this.state);
}

/*
蓝牙状态：
未知，
系统服务重启中，
不支持，
未授权，
蓝牙关闭，
蓝牙打开
* */
enum IDOBluetoothStateType {
  unknown,
  resetting,
  unsupported,
  unauthorized,
  poweredOff,
  poweredOn,
}

/*
连接状态：
断开连接，
连接中，
已连接，
// 首次连接成功后获取Mac地址，
断开连接中
*/
enum IDOBluetoothDeviceStateType {
  disconnected,
  connecting,
  connected,
  // getMacAddressConnected,
  disconnecting,
}

/*
* 连接错误
无状态
UUID或Mac地址异常
蓝牙关闭
主动断开连接（手机或固件发起）
连接失败
连接超时
发现服务失败
发现特征失败
配对异常
获取基本信息失败
app主动断开
*
* */
enum IDOBluetoothDeviceConnectErrorType {
  none,
  abnormalUUIDMacAddress,
  bluetoothOff,
  connectCancel,
  fail,
  timeOut,
  serviceFail,
  characteristicsFail,
  pairFail,
  informationFail,
  cancelByUser,
}

/*
* 超时
搜索
连接
指令
配对
* */
enum IDOBluetoothTimeoutType {
  scan,
  connect,
  commend,
  pair;
}

/*
* 扫描状态
扫描中
扫描结束
找到设备（android）
* */
enum IDOBluetoothScanType {
  scanning,
  stop,
  find,
}

/*
* 写数据状态
有响应
无响应
错误
* */
enum IDOBluetoothWriteType {
  withResponse,
  withoutResponse,
  error,
}

/*
* 配对状态
配对成功
配对取消
配对未知超时
* */
enum IDOBluetoothPairType {
  succeed,
  cancel,
  errorOrTimeOut,
}

/*
* spp:
* 开始连接
* 连接成功
* 连接失败
* 断链
* */
enum IDOBluetoothSPPStateType{
  onStart,
  onSuccess,
  onFail,
  onBreak,
}