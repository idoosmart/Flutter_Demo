package com.example.flutter_bluetooth.dfu.stat;


/**
 * Created by asus on 2017/11/24.
 */

public class EventStat {
    //-----------SDK初始化-----------
    public static void onInit() {
//        EventUpload.init();
//        Log log = ProtocolEvent.createInitLog();
//        LogTool.p("Event", log.toString());
//        EventUpload.uploadLog(log);
    }

    //---------------设备升级--------------
    public static void onDfuSuccess(long second, String effectTimeCause) {
    }

    public static void onDfuFailed(String effectCause) {
    }

    public static void onDfuErrorOccurred(String cause) {
    }

    public static void onDfuInDoingState(String deviceUniqueId) {
    }

    public static void onDfuInCompletedState(String deviceUniqueId) {
    }
}
