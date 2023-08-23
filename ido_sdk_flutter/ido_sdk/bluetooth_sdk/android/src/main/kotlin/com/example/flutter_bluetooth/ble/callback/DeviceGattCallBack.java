package com.example.flutter_bluetooth.ble.callback;

import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCharacteristic;

/**
 * Created by zhouzj on 2018/9/4.
 */

public class DeviceGattCallBack {

    public interface ICallBack{
        void onCharacteristicChanged(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic);
        void onCharacteristicWrite(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status);
    }

    public static void onCharacteristicChanged(final BluetoothGatt gatt, final BluetoothGattCharacteristic characteristic){
//        CallBackManager.getManager().runOnUIThread(new Runnable() {
//            @Override
//            public void run() {
        //这里回调时，不要强制让它运行在主线程
//                for (DeviceGattCallBack.ICallBack callBack : CallBackManager.getManager().getDeviceGattCallBackList()){
//                    callBack.onCharacteristicChanged(gatt, characteristic);
//                }
//            }
//        });
    }

    public static void onCharacteristicWrite(final BluetoothGatt gatt, final BluetoothGattCharacteristic characteristic, final int status){
//        CallBackManager.getManager().runOnUIThread(new Runnable() {
//            @Override
//            public void run() {
        //这里回调时，不要强制让它运行在主线程
//                for (DeviceGattCallBack.ICallBack callBack : CallBackManager.getManager().getDeviceGattCallBackList()){
//                    callBack.onCharacteristicWrite(gatt, characteristic, status);
//                }
//            }
//        });
    }
}
