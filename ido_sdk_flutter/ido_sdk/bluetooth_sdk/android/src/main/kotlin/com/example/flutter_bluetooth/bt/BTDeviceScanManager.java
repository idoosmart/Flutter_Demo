package com.example.flutter_bluetooth.bt;


import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import com.example.flutter_bluetooth.Config;
import com.example.flutter_bluetooth.logger.Logger;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;

@SuppressLint("MissingPermission")
public class BTDeviceScanManager {
    private IBTScanListener listener;
    private List<String> macAddressList = new ArrayList<>();
    private static BTDeviceScanManager manager;

    private BTDeviceScanManager() {
    }

    public static BTDeviceScanManager getManager() {
        if (manager == null) {
            manager = new BTDeviceScanManager();
        }
        return manager;
    }

    private BroadcastReceiver scanReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action == null)
                return;
            switch (action) {
                case BluetoothAdapter.ACTION_DISCOVERY_STARTED:
                    Logger.p("[BTScanManager] scanReceiver. discovery start");
                    break;
                case BluetoothAdapter.ACTION_DISCOVERY_FINISHED:
                    Logger.p("[BTScanManager] scanReceiver. discovery finished");
                    listener.onNotFind();
                    finished();
                    break;
                case BluetoothDevice.ACTION_FOUND:
                    BluetoothDevice dev = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
//                    short rssi = intent.getShortExtra(BluetoothDevice.EXTRA_RSSI, Short.MAX_VALUE);
                    findOneDevice(dev);
                    break;
            }
        }
    };


    public void startScan(IBTScanListener listener, String... macAddressList) {
        Logger.p("[BTScanManager] scan " + Arrays.toString(macAddressList));
        this.macAddressList.clear();
        if (!BluetoothAdapter.getDefaultAdapter().isEnabled()) {
            Logger.p("[BTScanManager] bluetooth is disEnable ");
            listener.onNotFind();
            return;
        }
        for (String macAddress : macAddressList) {
            BluetoothDevice device = findFromBondList(macAddress);
            if (device != null) {
                Logger.p("[BTScanManager] has find device" + macAddress + " from bondList.");
                listener.onFind(device);
            } else {
                this.macAddressList.add(macAddress);
            }
        }
        if (this.macAddressList.isEmpty()) {
            return;
        }
        this.listener = listener;
        registerReceiver();
        startDiscovery();
    }

    private void startDiscovery() {

        if (BluetoothAdapter.getDefaultAdapter().isDiscovering()) {
            BluetoothAdapter.getDefaultAdapter().cancelDiscovery();
        }

        boolean result = BluetoothAdapter.getDefaultAdapter().startDiscovery();
        Logger.p("[BTScanManager] startDiscovery. result=" + result);
    }

    private BluetoothDevice findFromBondList(String macAddress) {
        Set<BluetoothDevice> bondedDevices = BluetoothAdapter.getDefaultAdapter().getBondedDevices();
        for (BluetoothDevice d : bondedDevices) {
            if (macAddress.equals(d.getAddress())) {
                return d;
            }
        }
        return null;
    }


    private void registerReceiver() {
        try {
            Config.getApplication().unregisterReceiver(scanReceiver);
        } catch (Exception ignored) {
        }
        IntentFilter filter = new IntentFilter();
        filter.addAction(BluetoothAdapter.ACTION_DISCOVERY_STARTED);//蓝牙开始搜索
        filter.addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);//蓝牙搜索结束
        filter.addAction(BluetoothDevice.ACTION_FOUND);//蓝牙发现新设备(未配对的设备)
        Config.getApplication().registerReceiver(scanReceiver, filter);
    }


    private void findOneDevice(BluetoothDevice device) {
        if (device == null) return;
        Logger.p("[BTScanManager] find one device[" + device.getAddress() + "--" + device.getName() + "], macAddressList = "+macAddressList);
        if (macAddressList.contains(device.getAddress())) {
            Logger.p("[BTScanManager] has find device.");
            listener.onFind(device);
            macAddressList.remove(device.getAddress());
            if (macAddressList.isEmpty()) {
                finished();
            }
        }

    }

    private void finished() {
        Logger.p("[BTScanManager] finished.");
        release();
    }

    private void release() {
        Logger.p("[BTScanManager] release.");
        BluetoothAdapter.getDefaultAdapter().cancelDiscovery();
        Config.getApplication().unregisterReceiver(scanReceiver);
    }


}
