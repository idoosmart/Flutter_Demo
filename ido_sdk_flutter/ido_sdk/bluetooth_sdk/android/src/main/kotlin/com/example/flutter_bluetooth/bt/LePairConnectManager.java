package com.example.flutter_bluetooth.bt;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;

import com.example.flutter_bluetooth.Config;
import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.utils.PairedDeviceUtils;


public class LePairConnectManager {
    public static boolean isNeedCreateLePair(BluetoothGatt gatt,int devicePairFlag){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            BluetoothDevice targetDevice = gatt.getDevice();
            int transport = targetDevice.getType(); // 返回设备类型
            boolean isLe = (transport == BluetoothDevice.DEVICE_TYPE_LE)
                    || (transport == BluetoothDevice.DEVICE_TYPE_DUAL);
            Logger.p("[isNeedCreateBond] transport =  " + transport + " , BondState  = " + targetDevice.getBondState() + " , isLe = " + isLe);
//            if (isLe && targetDevice.getBondState() == BluetoothDevice.BOND_BONDED) {
//                // BLE设备已配对
//                return false;
//            }
        }
        if (PairedDeviceUtils.isPaired(gatt.getDevice().getAddress())){
            Logger.p("[isNeedCreateLePair] has paired. mac is " + gatt.getDevice().getAddress());
            return false;
        }
        Logger.p("[isNeedCreateLePair] not pair, need pair ");
        return true;
    }

    public interface IBondStateListener{
        void onBonded(String macAddress);
        void onBondFailed(String macAddress);
    }

    private static final String TAG = "LePairConnectManager";
    private String mMacAddress;
    private BluetoothDevice mBluetoothDevice;
    private static Handler mDelayHandler = new Handler(Looper.getMainLooper());

    private static LePairConnectManager manager;
    private LePairConnectManager(){}
    public static LePairConnectManager getManager() {
        if (manager == null) {
            manager = new LePairConnectManager();
            manager.init();
        }
        return manager;
    }

    private void init(){
        Logger.p("init ");
        final IntentFilter bondFilter = new IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED);
        bondFilter.addAction(BluetoothDevice.ACTION_ACL_CONNECTED);
        bondFilter.addAction(BluetoothDevice.ACTION_ACL_DISCONNECTED);
        bondFilter.addAction(BluetoothDevice.ACTION_PAIRING_REQUEST);
        Config.getApplication().registerReceiver(mBondStateBroadcastReceiver, bondFilter);
    }

    private IBondStateListener mBondStateListener;

    private final BroadcastReceiver mBondStateBroadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(final Context context, final Intent intent) {

            final BluetoothDevice tempDevice = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
            String action = intent.getAction();
            Logger.p("onReceive mac is "  + tempDevice.getAddress() + ";action=" + action);
            if (action.equals(BluetoothDevice.ACTION_ACL_CONNECTED)) {
                Logger.p("onReceive ACTION_ACL_CONNECTED " );
            } else if (action.equals(BluetoothDevice.ACTION_ACL_DISCONNECTED)) {
                Logger.p("onReceive ACTION_ACL_DISCONNECTED ");
            }else if (action.equals(BluetoothDevice.ACTION_BOND_STATE_CHANGED)) {
                final int bondState = intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, -1);
                Logger.p("onReceive bondState is " + bondState);
                if (bondState == BluetoothDevice.BOND_BONDED) {
                    Logger.p("createBond success, mac is" + tempDevice.getAddress());
                    if (tempDevice.getAddress().equals(mMacAddress)) {
                        if (mBondStateListener != null){
                            mBondStateListener.onBonded(tempDevice.getAddress());
                            mBondStateListener = null;
                        }
                    }
                } else if (bondState == BluetoothDevice.BOND_NONE) {
                    Logger.p("createBond onBondFailed, mac is" + tempDevice.getAddress());
                    int reason = intent.getIntExtra("android.bluetooth.device.extra.REASON", -1);
                    Logger.p("createBond failed. reason = " + reason);
                    if (tempDevice.getAddress().equals(mMacAddress)) {
                        if (mBondStateListener != null){
                            mBondStateListener.onBondFailed(tempDevice.getAddress());
                            mBondStateListener = null;
                        }
                    }
                }
            }else if(action.equals(BluetoothDevice.ACTION_PAIRING_REQUEST)){
                // 系统正在显示配对对话框
                try {
                    BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                    int variant = intent.getIntExtra(BluetoothDevice.EXTRA_PAIRING_VARIANT, -1);
                    Logger.p("BluetoothPair name : " + device.getName() +  " , mac = " + device.getAddress() + " , variant : " + variant);
                }catch (Exception e){
                    Logger.p("BluetoothPair ACTION_PAIRING_REQUEST e  " + e);
                }

            }
        }
    };

    public void connect(BluetoothDevice bluetoothDevice, IBondStateListener bondStateListener){
        Logger.p("[connect1] start, address=" + bluetoothDevice.getAddress());
        mMacAddress = bluetoothDevice.getAddress();
        mBondStateListener = bondStateListener;
        Logger.p("[connect1] create bond.");
//        bluetoothDevice.createBond();
        PairedDeviceUtils.createLeBond(bluetoothDevice);
    }
}
