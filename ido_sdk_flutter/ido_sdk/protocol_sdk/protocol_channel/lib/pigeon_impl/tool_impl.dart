import 'package:protocol_lib/protocol_lib.dart';
import 'package:protocol_alexa/protocol_alexa.dart';

import '../pigeon_generate/tools.g.dart';

class ToolImpl extends Tool {
  @override
  int compressToPNG(String inputFilePath, String outputFilePath) {
    return libManager.tools.compressToPNG(
        inputFilePath: inputFilePath, outputFilePath: outputFilePath);
  }

  @override
  String gpsAlgProcessRealtime(String json) {
    return libManager.tools.gpsAlgProcessRealtime(json: json);
  }

  @override
  int gpsInitType(int motionTypeIn) {
    libManager.tools.initParameter();
    return libManager.tools.gpsInitType(motionTypeIn);
  }

  @override
  String gpsSmoothData(String json) {
    return libManager.tools.gpsSmoothData(json: json);
  }

  @override
  Future<bool> makeEpoFile(String dirPath, String epoFilePath) {
    return libManager.tools
        .makeEpoFile(dirPath: dirPath, epoFilePath: epoFilePath, fileCount: 3);
  }

  @override
  int missedV2MissedCallEvt() {
    return libManager.callNotice.missedV2MissedCallEvt();
  }

  @override
  int png2Bmp(String inPath, String outPath, int format) {
    //TODO 待修改
    return libManager.tools.png2Bmp(
        inPath: inPath, outPath: outPath, format: ImageFormatType.abgr565);
  }

  @override
  int setV2CallEvt(String contactText, String phoneNumber) {
    return libManager.callNotice
        .setV2CallEvt(contactText: contactText, phoneNumber: phoneNumber);
  }

  @override
  int setV2NoticeEvt(
      int type, String contactText, String phoneNumber, String dataText) {
    return libManager.callNotice.setV2NoticeEvt(
        type: type,
        contactText: contactText,
        phoneNumber: phoneNumber,
        dataText: dataText);
  }

  @override
  bool setWriteStreamByte(bool isWrite) {
    return libManager.tools.setWriteStreamByte(isWrite);
  }

  @override
  int stopV2CallEvt() {
    return libManager.callNotice.stopV2CallEvt();
  }

  @override
  void logNative(String msg) {
    libManager.cache.recordNativeLog(msg);
  }

  @override
  VersionInfo? getSDKVersionInfo() {
    final verInfo = VersionInfo();
    verInfo.verMain = libManager.getSdkVersion;
    verInfo.verClib = libManager.getClibVersion;
    verInfo.verAlexa = IDOProtocolAlexa().getSdkVersion;
    return verInfo;
  }

  @override
  int mp3SamplingRate(String mp3FilePath) {
    return libManager.tools.mp3SamplingRate(mp3FilePath: mp3FilePath);
  }
}
