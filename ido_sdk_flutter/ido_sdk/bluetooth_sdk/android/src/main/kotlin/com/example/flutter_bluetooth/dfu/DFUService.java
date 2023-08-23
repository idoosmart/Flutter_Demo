package com.example.flutter_bluetooth.dfu;


import android.app.Activity;

import no.nordicsemi.android.dfu.DfuBaseService;

/**
 * Nodic芯片OTA方案的配置，需要配置service
 */
public class DFUService extends DfuBaseService {

    public DFUService(){
        super();
    }
    @Override
    protected Class<? extends Activity> getNotificationTarget() {
        return null;
    }

    @Override
    protected boolean isDebug() {
        return true;
    }
}
