import 'dart:typed_data';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as pkg_ffi;

import '../ido_protocol_fii.dart';

// 其他数据同步
extension IDOProtocolAPIExtSyncOthers on IDOProtocolAPI {
  // ------------------------------ v2闹钟同步 ------------------------------

  // /// 清除v2闹钟缓存
  // int cleanV2AlarmCache() {
  //   return bindings.ProtooclV2CleanAlarm();
  // }
  //
  // /// 开启同步v2闹钟,50ms下发一个闹钟直至发完为止
  // int startV2SetAlarmSync() {
  //   return bindings.ProtocolV2SetAlarmESyncStart();
  // }
  //
  // /// 暂停同步v2闹钟
  // int stopV2SetAlarmSync() {
  //   return bindings.ProtocolV2SetAlarmSyncStop();
  // }

  // ------------------------------ v2消息/来电提醒 ------------------------------

  ///  v2发送来电提醒以及来电电话号码和来电联系人(部分设备实现)
  ///
  /// contactText：联系人名称, phoneNumber：号码
  int setV2CallEvt({
    required String contactText,
    required String phoneNumber,
  }) {
    final contactTextUtf8 = contactText.toNativeUtf8();
    final phoneNumberUtf8 = phoneNumber.toNativeUtf8();
    return bindings.ProtocolV2SetCallEvt(
        contactTextUtf8.cast(), phoneNumberUtf8.cast());
  }

  /// v2发送信息提醒以及信息内容(部分设备实现)
  /// ```dart
  /// @param:type,信息类型
  /// {
  /// TYPE_SMS = 0x01
  /// TYPE_EMAIL = 0x02
  /// TYPE_WX = 0x03
  /// TYPE_QQ = 0x04
  /// TYPE_WEIBO = 0x05
  /// TYPE_FACEBOOK = 0x06
  /// TYPE_TWITTER = 0x07
  /// TYPE_WHATSAPP = 0x08
  /// TYPE_MESSENGER = 0x09
  /// TYPE_INSTAGRAM = 0x0A
  /// TYPE_LINKEDIN = 0x0B
  /// TYPE_CALENDAR = 0x0C
  /// TYPE_SKYPE = 0x0D
  /// TYPE_ALARM = 0x0E
  /// TYPE_VKONTAKTE = 0x10
  /// TYPE_LINE = 0x11
  /// TYPE_VIBER = 0x12
  /// TYPE_KAKAO_TALK = 0x13
  /// TYPE_GMAIL = 0x14
  /// TYPE_OUTLOOK = 0x15
  /// TYPE_SNAPCHAT = 0x16
  /// TYPE_TELEGRAM = 0x17
  /// TYPE_CHATWORK = 0x20
  /// TYPE_SLACK = 0x21
  /// TYPE_TUMBLR = 0x23
  /// TYPE_YOUTUBE = 0x24
  /// TYPE_PINTEREST_YAHOO = 0x25
  /// TYPE_TIKTOK = 0x26
  /// TYPE_REDBUS = 0X27
  /// TYPE_DAILYHUNT= 0X28
  /// TYPE_HOTSTAR = 0X29
  /// TYPE_INSHORTS = 0X2A
  /// TYPE_PAYTM = 0X2B
  /// TYPE_AMAZON = 0X2C
  /// TYPE_FLIPKART = 0X2D
  /// TYPE_PRIME = 0X2E
  /// TYPE_NETFLIX = 0X2F
  /// TYPE_GPAY = 0X30
  /// TYPE_PHONPE = 0X31
  /// TYPE_SWIGGY = 0X32
  /// TYPE_ZOMATO = 0X33
  /// TYPE_MAKEMYTRIP = 0X34
  /// TYPE_JIOTV = 0X35
  /// TYPE_KEEP = 0X36
  /// }
  /// contactText：通知内容, phoneNumber：号码
  /// ```dart
  int setV2NoticeEvt({
    required int type,
    required String contactText,
    required String phoneNumber,
    required String dataText,
  }) {
    final contactTextUtf8 = contactText.toNativeUtf8();
    final phoneNumberUtf8 = phoneNumber.toNativeUtf8();
    final dataTextUtf8 = dataText.toNativeUtf8();
    return bindings.ProtocolV2SetNoticeEvt(
      type,
      contactTextUtf8.cast(),
      phoneNumberUtf8.cast(),
      dataTextUtf8.cast(),
    );
  }

  /// v2发送来电提醒状态为来电已接, 告诉设备停止提醒用户(部分设备实现)
  int stopV2CallEvt() {
    return bindings.ProtocolV2StopCallEvt();
  }

  /// v2发送来电提醒状态为来电已拒, 告诉设备停止提醒用户(部分设备实现)
  int missedV2MissedCallEvt() {
    return bindings.ProtocolV2MissedCallEvt();
  }

  // ------------------------------ 同步配置 ------------------------------

  /// 获取同步配置状态
  ///
  /// return  0:空闲 1:忙碌, 正在同步
  int getSyncConfigStatus() {
    return bindings.GetSyncConfigStatus();
  }
}
