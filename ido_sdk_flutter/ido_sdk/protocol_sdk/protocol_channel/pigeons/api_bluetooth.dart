import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class BluetoothDelegate {

  /// 发送数据状态
  void writeState(WriteStateModel state);

  /// 收到数据
  void receiveData(ReceiveData data);

  /// 搜索设备结果
  void scanResult(List<DeviceModel>? list);

  /// 蓝牙状态
  void bluetoothState(BluetoothStateModel state);

  /// 设备状态状态
  void deviceState(DeviceStateModel state);

  /// spp状态
  void stateSPP(SPPStateModel state);

  /// spp文件写完成
  void writeSPPCompleteState(String btMacAddress);

  /// 监听dfu完成状态
  void dfuComplete();

  /// 监听dfu过程的错误
  void dfuError(String error);

  /// 监听升级进度
  /// 0-100
  void dfuProgress(int progress);

  /// 监听当前设备
  void changeCurrentDevice(DeviceModel device);

  /// 监听当前设备属性变更（目前针对btMacAddress 内部使用）
  void onCurrentDeviceAttrValChange(DeviceModel device);

  /// bt状态
  void stateBt(bool isPair);

}

@FlutterApi()
abstract class Bluetooth {

  /// 最后一次连接设备
  DeviceModel? currentDevice();

  /// 注册,程序开始运行调用
  /// heartPingSecond:心跳包间隔(ios)
  /// outputToConsole：控制台输出日志
  void register(int heartPingSecond, bool outputToConsole);

  /// 开始搜索
  /// macAddress（Android）:根据Mac地址搜索
  /// 返回指定搜索的设备，如未指定返回null
  @async
  List<DeviceModel?>? startScan(String? macAddress);

  /// 搜索筛选条件
  /// deviceName: 只搜索deviceName的设备
  /// deviceID：只搜索deviceID的设备
  /// macAddress：只搜索macAddress的设备
  /// uuid：只搜索uuid的设备
  void scanFilter(List<String>? deviceName, List<int>? deviceID, List<String>? macAddress, List<String>? uuid);

  /// 停止搜索
  void stopScan();

  /// 连接
  /// device: Mac地址必传，iOS要带上uuid，最好使用搜索返回的对象
  void connect(DeviceModel? device);

  /// 使用这个重连设备
  void autoConnect(DeviceModel? device);

  /// 取消连接
  @async
  bool cancelConnect(String? macAddress);

  /// 获取蓝牙状态
  @async
  BluetoothStateModel getBluetoothState();

  /// 获取设备连接状态
  @async
  DeviceStateModel getDeviceState(DeviceModel? device);

  /// 发送数据
  /// data:数据
  /// device: 发送数据的设备
  /// type:0 BLE数据, 1 SPP数据
  /// platform: 0 爱都, 1 恒玄, 2 VC
  @async
  WriteStateModel writeData(Uint8List data, DeviceModel? device, int type, int platform);

  /// bt配对（android）
  void setBtPair(DeviceModel device);

  /// 取消配对（android）
  void cancelPair(DeviceModel? device);

  /// 连接SPP
  void connectSPP(String btMacAddress);

  /// 断开SPP
  void disconnectSPP(String btMacAddress);

  ///发起dfu升级
  void startNordicDFU(DfuConfig config);

  /// 日志路径
  @async
  String? logPath();
}


/// 连接状态：
/// 断开连接，
/// 连接中，
/// 已连接，
/// 断开连接中
enum DeviceStateType {
  disconnected,
  connecting,
  connected,
  disconnecting,
}

class DeviceModel {
  /// rssi
  int? rssi;
  /// 设备名称
  String? name;
  /// 设备状态
  DeviceStateType? state;
  ///uuid
  String? uuid;
  ///mac address
  String? macAddress;
  /// ota mac address
  String? otaMacAddress;
  /// bt mac address
  String? btMacAddress;
  /// 设备ID
  int? deviceId;
  /// 设备类型 0:无效 1: 手表 2: 手环
  int? deviceType;
  /// 是否ota模式
  bool? isOta;
  ///是否泰凌微ota
  bool? isTlwOta;
  ///bt版本号
  int? bltVersion;
  ///配对状态（Android）
  bool? isPair;
  ///平台
  int? platform;

  }

/// 蓝牙状态：
/// 未知，
/// 系统服务重启中，
/// 不支持，
/// 未授权，
/// 蓝牙关闭，
/// 蓝牙打开
enum BluetoothStateType {
  unknown,
  resetting,
  unsupported,
  unauthorized,
  poweredOff,
  poweredOn,
}

/// 扫描状态
/// 扫描中
/// 扫描结束
/// 找到设备（android）
enum BluetoothScanType {
  scanning,
  stop,
  find,
}

class BluetoothStateModel {
  BluetoothStateType? type;
  BluetoothScanType? scanType;
}

/// 连接错误
/// 无状态
/// UUID或Mac地址异常
/// 蓝牙关闭
/// 主动断开连接
/// 连接失败
/// 连接超时
/// 发现服务失败
/// 发现特征失败
/// 配对异常
/// 获取基本信息失败
/// 设备已绑定并且不支持重复绑定
/// app 绑定的设备被重置了
/// 连接被终止，比如在 ota 中，不需要执行重连了

enum ConnectErrorType {
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
  deviceAlreadyBindAndNotSupportRebind,
  deviceHasBeenReset,
  connectTerminated
}

class DeviceStateModel {
  String? uuid;
  String? macAddress;
  DeviceStateType? state;
  ConnectErrorType? errorState;
}

/// 写数据状态
/// 有响应
/// 无响应
/// 错误
enum WriteType {
  withResponse,
  withoutResponse,
  error,
}

class WriteStateModel {
  /// 写入状态是否成功
  bool? state;
  /// uuid
  String? uuid;
  /// mac address
  String? macAddress;
  /// 写入类型
  WriteType? type;
}

class ReceiveData {
  /// 蓝牙字节数据
  Uint8List? data;
  /// uuid
  String? uuid;
  /// mac address
  String? macAddress;
  /// spp
  bool? spp;
  /// 0 爱都, 1 恒玄, 2 VC
  int? platform;
}

/// spp:
/// 开始连接
/// 连接成功
/// 连接失败
/// 断链
enum SPPStateType{
  onStart,
  onSuccess,
  onFail,
  onBreak,
}

class SPPStateModel {
  SPPStateType? type;
}

/// 设备升级
class DfuConfig {

  /// ota文件包路径
  String? filePath;

  ///设备的uuid, iOS使用
  String? uuid;

  ///设备的ble地址 安卓使用
  String? macAddress;

  ///设备的id
  String? deviceId;

  ///平台，默认为nordic，目前只支持nordic
  int? platform;

  ///设备是否支持配对，根据功能表V3_dev_support_pair_each_connect  安卓使用
  bool? isDeviceSupportPairedWithPhoneSystem;

  ///每次接受到包数，可不填
  int? prn;

  ///在重试过程中，如果多次升级失败，是否需要重启蓝牙
  bool? isNeedReOpenBluetoothSwitchIfFailed;

  ///最大重试次数
  int? maxRetryTime;

  ///RTK平台的OTA，在升级之前是否需要授权
  bool? isNeedAuth;

  ///RTK平台的OTA，模式
  int? otaWorkMode;

}

class DfuState {

  ///设备的ble地址
  String? macAddress;
  ///设备uuid
  String? uuid;

  ///状态
  ///[DEFAULT = -1]
  ///[PREPARE = 0] 一切准备就绪，开始进入dfu升级流程
  ///[DEVICE_ENTER_DFU_MODE = 1] 设备成功进入dfu模式
  ///[PROGRESS = 2] 进度
  ///[SUCCESS = 3] 升级完成，并已检测到手环已重启并处于正常状态
  ///[SUCCESS_BUT_UNKNOWN = 4] 升级完成，但无法检测手环处于什么状态，这个时候，你需提示用户“如果手环未重启，请重启手机蓝牙，重启app再尝试升级”
  ///[FAILED = 5] 升级失败，具体原因参考FailReason
  ///[CANCEL = 6] 取消了升级，设备取消或主动调用取消
  ///[RETRY = 7] 重试中，会返回当前重试次数
  int? state;
}
