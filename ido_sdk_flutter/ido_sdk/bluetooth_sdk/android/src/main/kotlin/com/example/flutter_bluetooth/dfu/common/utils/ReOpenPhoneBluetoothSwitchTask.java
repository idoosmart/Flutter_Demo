package com.example.flutter_bluetooth.dfu.common.utils;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;

import androidx.core.app.ActivityCompat;

import com.example.flutter_bluetooth.Config;
import com.example.flutter_bluetooth.dfu.BleDFUConstants;
import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.timer.TimeOutTaskManager;
import com.example.flutter_bluetooth.utils.CommonUtils;


/**
 * Created by zhouzj on 2018/7/7.\
 * 重启蓝牙
 */

public class ReOpenPhoneBluetoothSwitchTask {

    private ITaskStateListener listener;
    private int timeoutTaskId = -1;

    private BroadcastReceiver mBluetoothStatusReceiver = new BroadcastReceiver() {

        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (BluetoothAdapter.ACTION_STATE_CHANGED.equals(action)) {
                int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF);
                if (state == BluetoothAdapter.STATE_OFF) {
                    Logger.p(BleDFUConstants.LOG_TAG, "[ReOpenPhoneBluetoothSwitchTask] off");

                    delayOpenSwitch();
                } else if (state == BluetoothAdapter.STATE_ON) {
                    Logger.p(BleDFUConstants.LOG_TAG, "[ReOpenPhoneBluetoothSwitchTask] on");
                    finished();
                }
            }
        }
    };

    public void start(ITaskStateListener listener) {
        this.listener = listener;

        //关闭现有的蓝牙监听服务
//        CommonUtils.getAppContext().stopService(new Intent(CommonUtils.getAppContext(), DeviceConnectService.class));


        IntentFilter filter = new IntentFilter();
        filter.addAction(BluetoothAdapter.ACTION_STATE_CHANGED);
        CommonUtils.getAppContext().registerReceiver(mBluetoothStatusReceiver, filter);

        timeoutTaskId = TimeOutTaskManager.startTask(new TimeOutTaskManager.ITimeOut() {
            @Override
            public void onTimeOut() {
                Logger.p(BleDFUConstants.LOG_TAG, "[ReOpenPhoneBluetoothSwitchTask] task time out.");
                finished();
            }
        }, 1000 * 60);
        startReOpenSwitch();
    }

    private void startReOpenSwitch() {

        if (!checkPermission()) {
            Logger.p(BleDFUConstants.LOG_TAG, "[ReOpenPhoneBluetoothSwitchTask] no permission.");
            finished();
            return;
        }

        if (BluetoothAdapter.getDefaultAdapter().isEnabled()) {
            BluetoothAdapter.getDefaultAdapter().disable();
        } else {
            BluetoothAdapter.getDefaultAdapter().enable();
        }
    }

    private void delayOpenSwitch() {
        TimeOutTaskManager.startTask(new TimeOutTaskManager.ITimeOut() {
            @Override
            public void onTimeOut() {
                Logger.p(BleDFUConstants.LOG_TAG, "[ReOpenPhoneBluetoothSwitchTask] start enable....");
                if (ActivityCompat.checkSelfPermission(Config.getApplication(), Manifest.permission.BLUETOOTH_CONNECT) != PackageManager.PERMISSION_GRANTED) {
                    return;
                }
                BluetoothAdapter.getDefaultAdapter().enable();
            }
        }, 5000);
    }

    private boolean checkPermission() {
        int bluetoothAdmin = ActivityCompat.checkSelfPermission(CommonUtils.getAppContext(), Manifest.permission.BLUETOOTH_ADMIN);
        int bluetooth = ActivityCompat.checkSelfPermission(CommonUtils.getAppContext(), Manifest.permission.BLUETOOTH);

        return bluetoothAdmin == PackageManager.PERMISSION_GRANTED && bluetooth == PackageManager.PERMISSION_GRANTED;
    }

    public interface ITaskStateListener {
        void onFinished();
    }

    private void finished() {
        Logger.p(BleDFUConstants.LOG_TAG, "[ReOpenPhoneBluetoothSwitchTask] finished");
        TimeOutTaskManager.stopTask(timeoutTaskId);
        CommonUtils.getAppContext().unregisterReceiver(mBluetoothStatusReceiver);

        //启动现有的蓝牙监听服务
//        CommonUtils.getAppContext().startService(new Intent(CommonUtils.getAppContext(), DeviceConnectService.class));

        listener.onFinished();
    }
}
