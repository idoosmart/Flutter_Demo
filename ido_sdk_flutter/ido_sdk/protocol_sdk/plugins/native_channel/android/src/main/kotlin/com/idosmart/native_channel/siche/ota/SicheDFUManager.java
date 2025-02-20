package com.idosmart.native_channel.siche.ota;

import static android.content.Context.BIND_AUTO_CREATE;

import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.text.TextUtils;


import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.idosmart.native_channel.pigeon_generate.api_sifli.OTAUpdateState;
import com.idosmart.native_channel.siche.Config;
import com.idosmart.native_channel.siche.SicheToFlutterImpl;
import com.sifli.siflidfu_aidu.DFUImagePath;
import com.sifli.siflidfu_aidu.ISifliDFUService;
import com.sifli.siflidfu_aidu.Protocol;
import com.sifli.siflidfu_aidu.SifliDFUService;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * 思澈平台升级管理类
 *
 */
public class SicheDFUManager {
    public static final int PLATFORM_SICHE = 99;
    public static final int PLATFORM_SICHE_NOR = 98;
    private final static String TAG = "siche  ota-----";
    private static SicheDFUManager instance;
    private boolean mIsDoing = false;
    private Handler delayTimeHandler = new Handler(Looper.getMainLooper());
    ArrayList<DFUImagePath> paths = new ArrayList<>();
    LocalBroadcastReceiver localBroadcastReceiver = null;
    int progress = 0;
    private int retryTimes = 1;
    private int currentTimes = 0;
    private SicheDFUManager(){}
    private String update_mac;
    private boolean isIndfu = false;//是否是dfu 模式
    private int platForm = PLATFORM_SICHE;
    private static ISifliDFUService sifliDFUService;
    private static SifliDFUService.SifliDFUBinder mbinder;
    private static boolean isBond = false;
    private  ServiceConnection serviceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            mbinder = (SifliDFUService.SifliDFUBinder) service;
            sifliDFUService = mbinder.getDfuService();
            isBond = true;
            upgrade();
            printLog( "onServiceConnected.");
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            isBond = false;
            upgradeFailed();
            printLog("onServiceDisconnected.");
        }
    };
    public static SicheDFUManager getManager(){
        if (instance == null){
            instance = new SicheDFUManager();
        }
        return instance;
    }

    public boolean isUpdate(){
        return mIsDoing;
    }

    public boolean start(List<String> files, String mac){
        printLog("Start");
        if (mIsDoing){
            printLog("is doing ,ignore this action.");
            return false;
        }
        platForm = PLATFORM_SICHE;
       // SicheToFlutterImpl.INSTANCE.updateManageState(OTAUpdateState.INIT, "初始化");
        if (!checkParas(files,mac)){
          //  SicheToFlutterImpl.INSTANCE.updateManageState(OTAUpdateState.FAIL,"参数异常");
            return false;
        }
        update_mac = mac;
        mIsDoing = true;
        progress = 0;
        currentTimes = 0;
        isIndfu = false;
        upgrade();

        return true;
    }

    public void stop(){
        SifliDFUService.stop(getContext());
    }

    public boolean start(List<String> files, String mac,int mplatForm,boolean misIndfu){
        printLog("Start");
        if (mIsDoing){
            printLog("is doing ,ignore this action.");
            return false;
        }
        platForm = mplatForm;
        SicheToFlutterImpl.INSTANCE.updateManageState(OTAUpdateState.INIT,"初始化");
        if (!checkParas(files,mac)){
            SicheToFlutterImpl.INSTANCE.updateManageState(OTAUpdateState.FAIL,"参数异常");
            return false;
        }
        update_mac = mac;
        mIsDoing = true;
        progress = 0;
        currentTimes = 0;
        isIndfu = misIndfu;
        if(!isBond){
            printLog("service disconnected");
            Intent  serviceIntent = new Intent(Config.getApplication().getApplicationContext(),SifliDFUService.class);
            Config.getApplication().getApplicationContext().bindService(serviceIntent,serviceConnection,BIND_AUTO_CREATE);
        }else {
            upgrade();
        }

        return true;
    }

    private boolean checkParas(List<String> files, String mac) {
        if (files == null){
            printLog("paths is null");
            return false;
        }

        if (TextUtils.isEmpty(mac)){
            printLog("mac is null");
            return false;
        }
        paths.clear();
        if(platForm == PLATFORM_SICHE){
            for (String filePath:files){
                printLog("filepath:"+filePath);
                int id = -999;
                if(filePath.contains(".zip")){
                    id = Protocol.IMAGE_ID_RES;
                }else if(filePath.contains("ctrl_packet.bin")){
                    id = Protocol.IMAGE_ID_CTRL;
                }
                else if(filePath.contains("outER_IROM1.bin")){
                    id = Protocol.IMAGE_ID_HCPU;
                }
                else if(filePath.contains("outlcpu_flash.bin")){
                    id = Protocol.IMAGE_ID_LCPU;
                }
                else if(filePath.contains("outlcpu_rom_patch.bin")){
                    id = Protocol.IMAGE_ID_NAND_LCPU_PATCH;
                }
                else if(filePath.contains("outroot.bin")){
                    id= Protocol.IMAGE_ID_RES;
                }else if(filePath.contains("outdyn.bin")){
                    id = Protocol.IMAGE_ID_DYN;
                }
                printLog("image type: "+id);
                if(id != -999){ //防止里面有不需要的文件
                    //  DFUImagePath ctrlPath = new DFUImagePath("",Uri.fromFile(new File(folder_path)), Protocol.IMAGE_ID_CTRL);
                    DFUImagePath imagePath = new DFUImagePath( filePath,null, id);
                    //  paths.clear();
                    // paths.add(ctrlPath);
                    paths.add(imagePath);
                }
            }
            return true;
        }else if(platForm == PLATFORM_SICHE_NOR){
            for (String filePath:files){
                printLog("filepath:"+filePath);
                int id = -999;
                if(filePath.contains(".zip")){
                    id = Protocol.IMAGE_ID_RES;
                } else if (filePath.contains("ctrl_packet.bin")) {
                    id = Protocol.IMAGE_ID_CTRL;
                }
                else if (filePath.contains("outER_IROM1.bin") || filePath.contains("ER_IROM1.bin")) {
                    id = Protocol.IMAGE_ID_HCPU;
                } else if (filePath.contains("outlcpu_flash.bin")) {
                    id = Protocol.IMAGE_ID_LCPU;
                }
                else if(filePath.contains("outroot.bin")){
                    id = Protocol.IMAGE_ID_EX;
                }else if(filePath.contains("outER_IROM2.bin")){
                    id = Protocol.IMAGE_ID_RES;
                }else if(filePath.contains("outER_IROM3.bin")){
                    id = Protocol.IMAGE_ID_FONT;
                }
                printLog("image type: "+id);
                if(id != -999){ //防止里面有不需要的文件
                    //  DFUImagePath ctrlPath = new DFUImagePath("",Uri.fromFile(new File(folder_path)), Protocol.IMAGE_ID_CTRL);
                    DFUImagePath imagePath = new DFUImagePath( filePath,null, id);
                    //  paths.clear();
                    // paths.add(ctrlPath);
                    paths.add(imagePath);
                }
            }
            return  true;
        }
        return false;

    }



    private void release(){
        printLog("release");
        mIsDoing = false;
        progress = 0;
        currentTimes = 0;
        if(isBond){
            Config.getApplication().getApplicationContext().unbindService(serviceConnection);
            isBond = false;
        }
        LocalBroadcastManager.getInstance(getContext()).unregisterReceiver(localBroadcastReceiver);
        localBroadcastReceiver = null;
        if (delayTimeHandler != null) {
            delayTimeHandler.removeCallbacksAndMessages(null);
        }

    }

    private void upgrade(){
       printLog("upgrade... platform:"+platForm +"--misinduf:"+isIndfu);
        localBroadcastReceiver = new LocalBroadcastReceiver();
        regitsterDfuLocalBroadcast();
        if(paths==null || paths.size()==0){
            printLog("update paths null");
            return;
        }
        for(int i=0;i<paths.size();i++){
            DFUImagePath p = paths.get(i);
            printLog("paths : "+i+"---type:"+p.getImageType());
        }
        if(platForm == PLATFORM_SICHE){
            if (isIndfu){
                printLog("update is indfu");
                sifliDFUService.startActionDFUNand(getContext(),update_mac,paths,Protocol.DFU_MODE_RESUME,0);
            }else {
                printLog("update is normal");
                sifliDFUService.startActionDFUNand(getContext(),update_mac,paths,Protocol.DFU_MODE_NORMAL,0);
            }
        }else if(platForm == PLATFORM_SICHE_NOR){
            if (isIndfu){
                printLog("update nor is indfu");
                sifliDFUService.startActionDFUNorExt(getContext(),update_mac,paths,1,0);
            }else {
                printLog("update nor is normal");
                sifliDFUService.startActionDFUNorExt(getContext(),update_mac,paths,0,0);
            }

        }


    }

    /**
     * 重试
     */
    private void reTryUpdate(){
        printLog("update is reTryUpdate");
        if(platForm == PLATFORM_SICHE){
            sifliDFUService.startActionDFUNand(getContext(),update_mac,paths,Protocol.DFU_MODE_RESUME,0);
        }else if(platForm == PLATFORM_SICHE_NOR){
            sifliDFUService.startActionDFUNorExt(getContext(),update_mac,paths,1,0);
        }

    }

    private void regitsterDfuLocalBroadcast(){
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(SifliDFUService.BROADCAST_DFU_LOG);
        intentFilter.addAction(SifliDFUService.BROADCAST_DFU_PROGRESS);
        intentFilter.addAction(SifliDFUService.BROADCAST_DFU_STATE);
        LocalBroadcastManager.getInstance(getContext()).registerReceiver(new LocalBroadcastReceiver(),intentFilter);
    }

    class LocalBroadcastReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            switch (action){
                case SifliDFUService.BROADCAST_DFU_PROGRESS:
                    int type = intent.getIntExtra(SifliDFUService.EXTRA_DFU_PROGRESS_TYPE,0);
                    int currentProgress = intent.getIntExtra(SifliDFUService.EXTRA_DFU_PROGRESS,0);
                    if(progress != currentProgress){
                        progress = currentProgress;
                        printLog("progress: "+progress);
                        float p = (float) progress/100;
                        printLog("progress: "+p);
                       SicheToFlutterImpl.INSTANCE.updateManagerProgress( p);
                    }
                    break;
                case SifliDFUService.BROADCAST_DFU_LOG:
                    String dfulog = intent.getStringExtra(SifliDFUService.EXTRA_LOG_MESSAGE);
                    printLog("dfulog: "+dfulog);
                    break;
                case SifliDFUService.BROADCAST_DFU_STATE:
                    int dfuState = intent.getIntExtra(SifliDFUService.EXTRA_DFU_STATE,0);
                    int dfuStateResult = intent.getIntExtra(SifliDFUService.EXTRA_DFU_STATE_RESULT,0);
                    printLog("dfuState: "+dfuState);
                    printLog("dfuStateResult: "+dfuStateResult);
                    if(dfuState==100 ){
                        switch (dfuStateResult) {
                            case 0:
                                printLog("dfuState: success");
                                upgradeSuccess();
                                SicheToFlutterImpl.INSTANCE.updateManageState(OTAUpdateState.COMPLETED,"success");
                                break;
                            case 78:
                                printLog("dfuState: failed by user not permmsion");
                                upgradeFailed();
                                SicheToFlutterImpl.INSTANCE.updateManageState(OTAUpdateState.FAIL,"fail");
                                break;
                            case 10://调用重试
                                 if(currentTimes < retryTimes){
                                     printLog("dfuState:  retry update：curentTimes:"+currentTimes);
                                     currentTimes++;
                                     reTryUpdate();
                                 }else {
                                     printLog("dfuState: 超出重试次数");
                                     SicheToFlutterImpl.INSTANCE.updateManageState(OTAUpdateState.FAIL,"fail");
                                     upgradeFailed();
                                 }
                                break;
                            default:
                                printLog("dfuState: failed");
                                upgradeFailed();
                                SicheToFlutterImpl.INSTANCE.updateManageState(OTAUpdateState.FAIL,"fail");
                                break;
                        }
                    }
            }
        }
    }

    private Context getContext(){
        return Config.getApplication().getApplicationContext();
    }

    private void upgradeSuccess(){
        printLog("upgrade success");
        release();
    }
    private void upgradeFailed(){
        printLog("upgrade failed, exit!");
        release();
    }
    private void timeout(){
        printLog("timeout, upgrade failed!");
        release();
    }

    private static void printLog(String log){
        SicheToFlutterImpl.INSTANCE.log(TAG+log);
    }
}
