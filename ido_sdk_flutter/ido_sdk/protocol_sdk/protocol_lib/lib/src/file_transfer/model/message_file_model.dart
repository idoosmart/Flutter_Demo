import 'package:protocol_lib/src/private/logger/logger.dart';

import 'base_file_model.dart';

import '../type_define/type_define.dart';

/// 消息图标
class MessageFileModel extends BaseFileModel {
  /// 事件类型
  /// 参考 通消息通知
  /// ```dart
  /// 0x01：短信
  /// 0x02：邮件
  /// 0x03：微信
  /// 0x04：QQ
  /// 0x05：新浪微博
  /// 0x06：facebook
  /// 0x07：twitter
  /// 0x08：WhatsApp
  /// 0x09：Messenger
  /// 0x0A：Instagram
  /// 0x0B：Linked in
  /// 0x0C：日历
  /// 0x0D：skype；
  /// 0x0E：闹钟
  /// 0x0F：pokeman
  /// 0x10：VKontakte
  /// 0x11：Line
  /// 0x12：Viber
  /// 0x13：KakaoTalk
  /// 0x14：Gmail
  /// 0x15：Outlook,
  /// 0x16：Snapchat
  /// 0x17：TELEGRAM
  /// 0x18：other
  /// 0x20：chatwork
  /// 0x21：slack
  /// 0x22：Yahoo Mail
  /// 0x23：Tumblr,
  /// 0x24：Youtube
  /// 0x25：Yahoo Pinterest
  /// 0x26：TikTok
  /// 0x27：Redbus
  /// 0x28：Dailyhunt
  /// 0x29：Hotstar
  /// 0x2A：Inshorts
  /// 0x2B：Paytm
  /// 0x2C：Amazon
  /// 0x2D：Flipkart
  /// 0x2E：Prime
  /// 0x2F：Netflix
  /// 0x30：Gpay
  /// 0x31：Phonpe
  /// 0x32：Swiggy
  /// 0x33：Zomato
  /// 0x34：Make My trip
  /// 0x35：Jio Tv
  /// 0x36：keep
  /// 0x37：Microsoft
  /// 0x38：WhatsApp Business
  /// 0x39：niosefit
  /// 0x3A：missed_calls未接来电
  /// 0x3B：Gpap
  /// 0x3C：YTmusic
  /// 0x3D：Uber
  /// 0x3E：Ola
  /// 0x3F：事项提醒
  /// 0x40：Google meet
  /// ```
  final int evtType;

  /// 应用包名
  final String packName;

  MessageFileModel(
      {required super.filePath,
      required super.fileName,
      required this.evtType,
      required this.packName,
      super.fileSize})
      : super(fileType: FileTransType.msg);

  @override
  String toString() {
    return 'MessageFileModel{evtType: $evtType, packName: $packName, fileType: $fileType, '
        'filePath: $filePath, fileName: $fileName, fileSize: $fileSize, '
        'originalFileSize: $originalFileSize}';
  }
}
