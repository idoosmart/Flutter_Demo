//package com.example.flutter_bluetooth.dfu.rtk.auth;
//
//
//import android.text.TextUtils;
//import android.util.Log;
//
//import com.example.flutter_bluetooth.dfu.BleDFUConstants;
//import com.example.flutter_bluetooth.logger.Logger;
//import com.example.flutter_bluetooth.timer.TimeOutTaskManager;
//import com.example.flutter_bluetooth.utils.ByteDataConvertUtil;
//import com.example.flutter_bluetooth.utils.GsonUtil;
//import com.realsil.sdk.dfu.DfuConstants;
//import com.realsil.sdk.dfu.DfuException;
//import com.realsil.sdk.dfu.image.BinFactory;
//import com.realsil.sdk.dfu.image.LoadParams;
//import com.realsil.sdk.dfu.model.BinInfo;
//
//import java.util.Locale;
//
///**
// * 对rkt设备进行ota授权操作
// */
//
//public class RtkAuthTask {
//    private static boolean isDoing = false;
//
//    private static final int MAX_RETRY_TIMES = 3;
//    private int retryTimes = 0;
//    private IResult iResult;
//    private int mTimeoutTaskId = -1;
//    private String filePath;
//
//    public RtkAuthTask(String filePath){
//        this.filePath = filePath;
//    }
//
//    private DeviceResponseCommonCallBack.ICallBack iCallBack = new DeviceResponseCommonCallBack.ICallBack(){
//
//        @Override
//        public void onResponse(int eventType, String jsonData) {
//            if (eventType != ProtocolEvt.APP_OTA_AUTH){
//                return;
//            }
//            Logger.p(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] response json is " + jsonData);
//            if (TextUtils.isEmpty(jsonData)){
//                failed();
//            }else {
//                RtkAuth.AuthResult result = GsonUtil.analysisJsonToObject(jsonData, RtkAuth.AuthResult.class);
//                if (result == null || result.errCode != 0 ){
//                    failed();
//                }else {
//                    success();
//                }
//            }
//        }
//
//    };
//
//
//
//
//    public void start(IResult iResult){
//        if (isDoing){
//            Logger.e(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] is doing, ignore this action!");
//            return;
//        }
//
//        Logger.p(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] start...");
//        this.iResult = iResult;
//        CallBackManager.getManager().registerDeviceResponseCommonCallBack(iCallBack);
//
//        isDoing = true;
//
//        startTimeOutTask();
//        sendAuthCmd();
//
//    }
//
////    private void sendAuthCmd(){
////        BasicInfo basicInfo = MultiDeviceSPDataUtils.getInstance().getBasicInfo();
////        if (basicInfo == null){
////            BLECmdUtils.getBasicInfo();
////        }else {
////            RtkAuth.AuthPara authPara = new RtkAuth.AuthPara();
////            authPara.deviceId = basicInfo.deivceId;
////            authPara.version = getVersionFromBinFile();
////
////            if (authPara.version < 0){
////                Logger.e(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] get binInfo's version failed: " + GsonUtil.toJson(authPara));
////                return;
////            }
////
////            Logger.p(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] auth para is " + GsonUtil.toJson(authPara));
////            SoLibNativeMethodWrapper.writeJsonData(ByteDataConvertUtil.getJsonByte(GsonUtil.toJson(authPara)), ProtocolEvt.APP_OTA_AUTH);
////        }
////    }
//    private void sendAuthCmd(){
//        RtkAuth.AuthPara authPara = new RtkAuth.AuthPara();
//        authPara.deviceId = getVersionFromBinFile();
//
//        if (authPara.deviceId < 0){
//            Logger.e(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] get binInfo's version failed: " + GsonUtil.toJson(authPara));
//            failed();
//            return;
//        }
//
//        Logger.p(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] auth para is " + GsonUtil.toJson(authPara));
//        SoLibNativeMethodWrapper.writeJsonData(ByteDataConvertUtil.getJsonByte(GsonUtil.toJson(authPara)), ProtocolEvt.APP_OTA_AUTH);
//    }
//
//    private int getVersionFromBinFile(){
//        LoadParams.Builder builder = new LoadParams.Builder()
//                .setPrimaryIcType(DfuConstants.IC_BEE2)
//                .setFilePath(filePath);
//        try {
//            BinInfo mBinInfo = BinFactory.loadImageBinInfo(builder.build());
//            if (mBinInfo != null){
//                Logger.p(BleDFUConstants.LOG_TAG_RTK, "bin file's BinInfo = " + mBinInfo.toString());
//
//                int temp = mBinInfo.version;
//                int a = temp & 15;
//                int b = temp >> 4 & 255;
//                int c = temp >> 12 & 32767;
//                int d = temp >> 27 & 31;
//
//                String sourceVersion = String.format(Locale.US, "%d.%d.%d.%d", a, b, c, d);
//                Logger.p(BleDFUConstants.LOG_TAG_RTK, "bin file's version is " + sourceVersion);
//
//                if (d > 0){
//                    c = c | (1<<15);
//                }
//
//                return c;
//            }
//        } catch (DfuException e) {
//            Logger.e(BleDFUConstants.LOG_TAG_RTK, e.getMessage());
//        }
//
//        return -1;
//    }
//
//
//    private void restart(){
//        if (retryTimes > MAX_RETRY_TIMES){
//            Logger.p(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] out of max retry times.");
//            failed();
//            return;
//        }
//
//        Logger.p(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] restart...");
//        retryTimes ++;
//
//        startTimeOutTask();
//        sendAuthCmd();
//
//    }
//
//
//    private void success(){
//        Logger.p(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] rtk auth success!");
//        finished();
//        iResult.onSuccess();
//
//    }
//
//    private void failed(){
//        Logger.e(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] rtk auth failed!");
//        finished();
//        iResult.onFailed("");
//
//    }
//
//    public void stop(){
//        if (!isDoing){
//            return;
//        }
//        Logger.p(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] stop task!");
//        release();
//    }
//
//    private void finished(){
//        Logger.p(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] finished!");
//        TimeOutTaskManager.stopTask(mTimeoutTaskId);
//        release();
//    }
//
//    private void release(){
//        isDoing = false;
//        CallBackManager.getManager().unregisterDeviceResponseCommonCallBack(iCallBack);
//    }
//
//    private void startTimeOutTask(){
//        mTimeoutTaskId = TimeOutTaskManager.startTask(new TimeOutTaskManager.ITimeOut() {
//            @Override
//            public void onTimeOut() {
//                Log.e(BleDFUConstants.LOG_TAG_RTK, "[RtkAuthTask] onTimeOut, retry...");
//                restart();
//
//            }
//        }, 5000);
//    }
//
//    public interface IResult{
//        void onSuccess();
//        void onFailed(String error);
//    }
//}
