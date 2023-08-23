import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';

extension Compare on Uint8List {
  bool compare(Uint8List second) {
    return listEquals(this, second);
  }
}

class IDOBluetoothTool {
  static String addColon(String str) {
    if (str.contains(":")) {
      return str;
    }
    List<String> colonStr = [];
    for (int i = 0; i < str.length; i++) {
      colonStr.add(str.substring(i, i + 1));
    }
    return colonStr.reduce((value, element) {
      return value.length % 3 == 2 ? "$value:$element" : "$value$element";
    });
  }

  //OTA可能导致Mac地址+1，对相差1范围的Mac地址都算同一个
  static bool nearMacAddressCompare(String? macAddress) {
    final beforMacAddress = bluetoothManager.currentDevice?.macAddress ?? "";
    if (beforMacAddress.length < 12) {
      // print('nearMacAddressCompare_beforMacAddress = $beforMacAddress');
      return false;
    }
    final subStr1 = beforMacAddress.substring(0, 10);
    final subStr2 = beforMacAddress.substring(10, 12);
    final subInt = int.tryParse(subStr2, radix: 16) ?? 0;
    final addMacAdress =
        subStr1 + uint8ToHex(Uint8List.fromList([(subInt + 0x01)]));
    final subtraction =
        subStr1 + uint8ToHex(Uint8List.fromList([(subInt - 0x01)]));
    // print('macAddress = $macAddress , beforMacAddress = $beforMacAddress , '
    // 'addMacAdress = $addMacAdress , subtraction = $subtraction');
    return macAddress == beforMacAddress ||
        macAddress == addMacAdress ||
        macAddress == subtraction;
  }

  ///兼容用":"分割的情况 OTA可能导致Mac地址+1，对相差1范围的Mac地址都算同一个
  static bool nearTwoMacAddressCompare(
      String? baseMacAddress, String? compareMacAddress) {
    final baseAddress = baseMacAddress?.replaceAll(':', '');
    final compareAddress = compareMacAddress?.replaceAll(':', '');

    final beforMacAddress = baseAddress ?? "";
    if (beforMacAddress.length < 12) {
      // print('nearMacAddressCompare_beforMacAddress = $beforMacAddress');
      return false;
    }
    final subStr1 = beforMacAddress.substring(0, 10);
    final subStr2 = beforMacAddress.substring(10, 12);
    final subInt = int.tryParse(subStr2, radix: 16) ?? 0;

    final addMacAdress =
        subStr1 + uint8ToHex(Uint8List.fromList([(subInt + 0x01)]));
    final subtraction =
        subStr1 + uint8ToHex(Uint8List.fromList([(subInt - 0x01)]));

    return compareAddress == beforMacAddress ||
        compareAddress == addMacAdress ||
        compareAddress == subtraction;
  }

  //字符串反转
  static String reversedString(String str) {
    List<int> runechars = str.runes.toList();
    return String.fromCharCodes(runechars.reversed);
  }

  //Uint8List转16进制字符串
  static String uint8ToHex(Uint8List byteArr) {
    if (byteArr.isEmpty) {
      return "";
    }

    Uint8List result =
        Uint8List(byteArr.length << 1); //创建一个byteArr.length两倍大的数组以存储16进制字符
    var hexTable = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F'
    ]; //16进制字符表
    //下面的for循环是通过codeUnitAt()方法取byteArr每一位对应的字符串的“UTF-16代码单元”，如果去掉.codeUnitAt()其实也就直接是16进制字符串
    for (var i = 0; i < byteArr.length; i++) {
      var bit = byteArr[i]; //取传入的byteArr的每一位
      var index = bit >> 4 & 15; //右移4位,取剩下四位,&15相当于&F,也就是&1111
      var i2 = i << 1; //byteArr的每一位对应结果的两位,所以对于结果的操作位数要乘2
      result[i2] = hexTable[index].codeUnitAt(0); //左边的值取字符表,转为Unicode放进resut数组
      index = bit & 15; //取右边四位,相当于01011010&00001111=1010
      result[i2 + 1] =
          hexTable[index].codeUnitAt(0); //右边的值取字符表,转为Unicode放进resut数组
    }
    //这里为了优化转换成一整个String的效率，所以就在上面的循环中先转成codeUnit再通过String的实例方法来生成字符串，否则需要用result.join("")，这个join()方法的效率低于String.fromCharCodes()方法
    return String.fromCharCodes(result); //Unicode转回为对应字符,生成字符串返回
  }
}
