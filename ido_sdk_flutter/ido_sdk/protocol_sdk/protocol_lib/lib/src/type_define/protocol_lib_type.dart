/// 状态通知
enum IDOStatusNotification {
  /// 协议库完成蓝牙库桥接，此时缓存数据已经初始化
  protocolConnectCompleted,

  /// 功能表获取完成
  functionTableUpdateCompleted,

  /// 设备信息获取完成
  deviceInfoUpdateCompleted,

  /// 三级版本获取完成
  deviceInfoFwVersionCompleted,

  /// 绑定授权码异常，设备强制解绑
  unbindOnAuthCodeError,

  /// 绑定状态异常，需要解绑 (本地绑定状态和设备信息不一致时触发)
  unbindOnBindStateError,

  /// 快速配置完成
  fastSyncCompleted,

  /// 快速配置失败，需业务层重新触发快速配置
  fastSyncFailed,

  // /// 快速配置超时，收到不到成功或失败时，且超过8秒时上报 （容易对业务层造成困惑 先去掉）
  // fastSyncTimeout,

  /// BT MacAddress获取完成
  deviceInfoBtAddressUpdateCompleted,

  /// 快速配置获取到的macAddress和markConnectedDevice传入的不一致时上报此错误
  macAddressError,

  /// 同步健康数据中
  syncHealthDataIng,

  /// 同步健康数据完成
  syncHealthDataCompleted,

  // 0:成功/一致；1:失败；2:失败，账户不一致；3:失败，无账户
  /// 成功 / 一致（恒玄专用）
  accountMatched,

  /// 失败（恒玄专用）
  accountFailed,

  /// 失败，账号不一致（恒玄专用）
  accountNotMatch,

  /// 失败，无账户（恒玄专用）
  accountNil,

  /// 快速配置开始
  fastSyncStarting,
}

/// OTA类型
enum IDOOtaType {
  /// 无升级
  none,

  /// 泰凌微设备OTA
  telink,

  /// nordic设备OTA
  nordic,
}

/// 设备通知
class IDODeviceNotificationModel {
  /// 监听设备状态
  ///
  /// code详细说明如下:
  /// ```dart
  /// 0 无效
  /// 1 手环已经解绑
  /// 2 心率模式改变
  /// 3 血氧产生数据，发生改变
  /// 4 压力产生数据，发生改变
  /// 5  Alexa识别过程中退出
  /// 6 固件发起恢复出厂设置，通知app弹框提醒
  /// 7 app需要进入相机界面（TIT01定制）
  /// 8 sos事件通知（205土耳其定制）
  /// 9 alexa设置的闹钟，固件修改，需要发送对应的通知位给app，app收到后发送获取V3的闹钟命令
  /// 10 固件有删除日程提醒，app这边( cmd = 0x33 ,  cmd_id = 0x36 )查询列表，要更新对应的列表数据
  /// 11 固件端有修改对应的表盘子样式，通知app获取（command\_id为0x33， key为 0x5000）
  /// 12 固件通知ios更新通知图标和名字
  /// 13 固件通知app图标已经更新，通知app获取已经更新的图标状态
  /// 14 固件请求重新设置天气，app收到收，下发天气数据
  /// 15 固件步数每次增加2000步，设备请求app同步数据，app调用同步接口
  /// 16 固件探测到睡眠结束，请求app同步睡眠数据，app调用同步接口同步
  /// 17 固件三环数据修改，通知app更新三环数据
  /// 18 固件充满电完成发送提醒，app收到后通知栏显示设备充电完成
  /// 19 结束运动后，手动测量心率后，手动测量血氧后，手动测量压力后，设备自动请求同步，先检查链接状态，未连接本次同步不执行，满足下个自动同步条件后再次判断发起同步请求
  /// 20 固件修改 心率通知状态类型、压力通知状态类型、血氧通知状态类型、生理周期通知状态类型、健康指导通知状态类型、提醒事项通知状态类型通知app更新心率、压力、血氧、生理周期、健康指导、提醒事项通知状态类型
  /// 21 固件压力值计算完成，通知app获取压力值
  /// 22 固件通知app，固件压力校准失败(固件退出测量界面/检测失败/检测超时/未佩戴)
  /// 23 固件产生心率过高或者过低提醒时，通知app获取心率数据
  /// 24 固件通知app bt蓝牙已连接
  /// 25 固件通知app bt蓝牙断开连接
  /// 26 固件蓝牙通话开始
  /// 27 固件蓝牙通话结束
  /// 28 新版本固件每隔4分30秒发送一个通知命令，用于修复ios 会显示离线的问题
  /// 29 通知app运动开始
  /// 30 通知app运动结束
  /// 31 固件重启发送通知给app  （app收到通知需要获取固件版本信息）
  /// 32 设备空闲时（没有使用alexa），需要上报通知给app（时间间隔为1小时）
  /// 33 固件整理空间完成通知app继续下传表盘文件
  /// 34 固件通知app结束寻找手环指令 （对应6.3寻找手环）
  /// 35 固件进入省电模式通知app
  /// 36 固件退出省电模式通知app
  /// 37 固件通知请求app下发设置gps热启动参数
  /// 38 固件传输原始数据完成，通知app获取特性向量信息
  /// 39 固件通知app，固件血压校准失败(固件退出测量界面/检测失败/检测超时/未佩戴)
  /// 40 固件传输原始数据完成，没有特性向量信息，通知app数据采集结束
  /// 41 v3健康数据同步单项数据完成通知 (android 内部使用）
  /// 42 固件整理gps数据空间完成通知app下发gps文件
  /// 43 固件升级EPO.dat文件失败，通知app再次下发EPO.dat文件（最多一次）
  /// 44 固件升级EPO.dat文件成功
  /// 45 固件升级GPS失败，通知app重新传输
  /// 46 固件升级GPS成功
  /// 47 发起运动时, 固件GPS异常，通知app           
  /// 48 固件润丰外设信息更新，通知app获取           
  /// 49 固件通知用户取消ble和手表配对,app弹窗处理  
  /// 50 固件通知app bt配对完成                  
  /// 51 固件设置运动排序,通知app获取运动排序信息
  /// 52 固件全天步数目标参数有更改,通知app获取全天步数目标(0208)      
  /// 53 固件通知app固件进入血压校准界面        
  /// 54 固件自动识别开关状态更新,通知app获取运动自动识别开关状态(02EA) 
  /// 55 固件慢速模式切换慢速模式
  /// 56 固件快速模式切换快速模式
  /// 57 固件更新mtu，APP下发获取mtu更新本地记录的mtu<br />(本地记录的mtu大小大于20Bytes不更新)     
  /// 58 固件电量变化，APP下发获取电量信息
  /// 59 当前处于DFU模式(思澈平台)
  /// 60 固件单位切换，通知APP获取单位(0222)    
  /// 61 固件修改菜单列表(快捷列表)，通知APP获取(02A8)
  /// 62 固件修改本地语言，通知APP获取(0222)    
  /// 63 固件修改当前表盘，通知APP获取
  /// 64 固件测量完成，通知APP获取结果(0606)
  /// 65 固件修改智能心率模式，通知APP获取智能心率模式参数(0263)
  /// 66 固件通知APP升级血压模型算法文件(.bpalgbin)
  /// 67 固件修改压力开关状态，通知APP获取压力开关参数(0245)
  /// 68 固件修改血氧饱和度开关状态，通知APP获取血氧饱和度开关参数(0244)
  /// 69 固件修改电子卡片内容，通知APP获取电子卡片内容
  /// 70 固件修改晨报内容，通知APP获取晨报内容
  /// 71 固件修改语音备忘录，通知APP获取语音备忘录内容
  /// 72 APP发起测量功能的时候，固件通知APP手表未佩戴的异常
  /// 73 APP发起的测量身体成分测量失败，通知APP
  /// 74 固件AI语音功能退出，通知APP
  /// 75 固件AI表盘功能退出，通知APP
  /// 76 固件通知APP更新OTA
  /// 77 固件遇到账户不一致，用户点击取消配对
  /// 78 固件遇到账户不一致，用户点击确定恢复出厂
  /// 82 固件点击连接新手机, 通知app断联
  /// 83 固件通知APP需要更新EPO(星历)文件
  /// ```
  final int? dataType;

  ///  1 闹钟已经修改 2 固件过热异常告警 4 亮屏参数有修改 8 抬腕参数有修改
  ///  16  勿擾模式获取 32 手机音量的下发
  final int? notifyType;

  /// 每个消息对应一个ID
  final int? msgId;

  ///  0 无效 1 自定义短信1（正在开会，稍后联系）2 自定义短信2
  final int? msgNotice;

  ///  01 ACC  加速度 02 PPG  心率 03 TP   触摸 04 FLASH
  ///  05 过热（PPG）06 气压 07 GPS 08 地磁
  final int? errorIndex;

  /// 控制事件
  /// ```dart
  /// 551 设备控制app音乐开始
  /// 552 设备控制app音乐暂停
  /// 553 设备控制app音乐停止
  /// 554 设备控制app音乐上一首
  /// 555 设备控制app音乐下一首
  /// 556 设备控制app拍照单拍
  /// 557 设备控制app拍照连拍
  /// 558 设备控制app音量加
  /// 559 设备控制app音量减
  /// 560 设备控制app打开相机
  /// 561 设备控制app关闭相机
  /// 562 设备控制app接听电话
  /// 563 设备控制app拒接电话
  /// 565 设备控制app音乐音量百分比
  /// 567 设备控制打开APP相机，进入拍照预览功能
  /// 568 设备控制暂停拍照预览，停止传输照片流
  /// 569 设备控制关闭APP相机，退出拍照预览功能
  /// 570 设备控制app寻找手机开始
  /// 571 设备控制app寻找手机结束
  /// 572 设备通知app防丢启动
  /// 574 设备通知app一键呼叫开始
  /// 575 设备通知传感器数据
  /// 576 设备通知app操作类型
  /// 577 设备通知app数据更新
  /// 578 设备请求版本检查
  /// 579 设备请求ota
  /// 580 设备通知app短信信息
  /// 581 设备控制app相机
  /// 591 设备通知固件喇叭音量修改
  /// ```
  final int? controlEvt;

  /// 控制事件返回值（部分事件才有）
  final String? controlJson;

  IDODeviceNotificationModel(
      {this.dataType,
      this.notifyType,
      this.msgId,
      this.msgNotice,
      this.errorIndex,
      this.controlEvt,
      this.controlJson});

  Map<String, dynamic> toMap() {
    return {
      'dataType': dataType,
      'notifyType': notifyType,
      'msgId': msgId,
      'msgNotice': msgNotice,
      'errorIndex': errorIndex,
      'controlEvt': controlEvt,
      'controlJson': controlJson,
    };
  }
}

/// 指令优先级
enum IDOCmdPriority { veryHigh, high, normal, low }

enum IDOAudioRate {
  rate44_1kHz,
}