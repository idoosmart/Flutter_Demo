import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

//生产环境
const bool inProduction = bool.fromEnvironment("dart.vm.product");
//非生产环境
const bool nonProduction = !bool.fromEnvironment("dart.vm.product");

//特征UUID
final characteristicUUID = {
  "command": "00000af6-0000-1000-8000-00805f9b34fb",
  "health": "00000af1-0000-1000-8000-00805f9b34fb",
  "read": "00001534-1212-EFDE-1523-785FEABCD123",
  "notify": [
    "00000af7-0000-1000-8000-00805f9b34fb",
    "00000af2-0000-1000-8000-00805f9b34fb",
    "00001531-1212-EFDE-1523-785FEABCD123"
  ]
};

final servicesUUID = {"UUID":["00001530-1212-EFDE-1523-785FEABCD123","00000af0-0000-1000-8000-00805f9b34fb","0000fe59-0000-1000-8000-00805f9b34fb","00010203-0405-0607-0809-0a0b0c0d1912"]};

final isOtaUUID = ["00001530-1212-EFDE-1523-785FEABCD123","FE59","00010203-0405-0607-0809-0a0b0c0d1912","0000fe59-0000-1000-8000-00805f9b34fb"];

final deviceMapKey = Platform.isAndroid ? "macAddress" : "uuid";

//获取MacAddress指令
final getMacAddressCommend = Uint8List.fromList([0x02, 0x04]);
//心跳指令  [0x02, 0xA0]
final heartPingCommend = Uint8List.fromList([0x02, 0x03]);
//获取配对指令
final getPairCommend = Uint8List.fromList([0x02,0x10]);
//打开ANCS
final openANCSCommend = Uint8List.fromList([0x06,0x30]);
//设置配对指令
final openPairCommend = Uint8List.fromList([0x03,0x30,0x55,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00]);
//回设置配对指令  第4位：0x01 配对成功 0x02 配对取消 0x03 配对未知超时
final receiveOpenPairCommend = Uint8List.fromList([0x03,0x30]);

// 升级
const RX_UPDATE_UUID = "00001530-1212-efde-1523-785feabcd123";
// 升级
const RX_UPDATE_UUID_0XFE59_ANDROID = "0000fe59-0000-1000-8000-00805f9b34fb";
const RX_UPDATE_UUID_0XFE59_IOS = "fe59";
//realme IDw02 0101升级模式，泰凌微升级服务
const RX_UPDATE_UUID_0X0203 = "00010203-0405-0607-0809-0a0b0c0d1912";
//泰凌微设备升级时的名称
const RX_UPDATE_NAME_TLW = "tlwota";

///channel
// const String sendStateChannel = "sendState";