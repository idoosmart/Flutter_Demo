package com.example.flutter_bluetooth.bt;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothProfile;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Handler;
import android.os.Looper;

import com.example.flutter_bluetooth.Config;
import com.example.flutter_bluetooth.utils.CommonUtils;
import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.utils.PairedDeviceUtils;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.List;
import java.util.Set;
import java.util.UUID;

public class HIDConnectManager {
    public static final UUID INPUT_DEVICE_UUID = UUID.fromString("00001812-0000-1000-8000-00805f9b34fb");// 输入设备类型

    public static boolean isNeedCreateBond(BluetoothGatt gatt) {
        if (gatt.getService(INPUT_DEVICE_UUID) == null) {
            return false;
        }

        if (PairedDeviceUtils.isPaired(gatt.getDevice().getAddress())) {
            Logger.p("[isNeedCreateBond] has paired. mac is " + gatt.getDevice().getAddress());
            return false;
        }

        return true;
    }

    public interface IBondStateListener {
        void onBonded(String macAddress);
    }

    private static final String TAG = "HIDConnectManager";
    private String mMacAddress;
    private BluetoothDevice mBluetoothDevice;
    private static Handler mDelayHandler = new Handler(Looper.getMainLooper());

    private static HIDConnectManager manager;

    private HIDConnectManager() {
    }

    public static HIDConnectManager getManager() {
        if (manager == null) {
            manager = new HIDConnectManager();
            manager.init();
        }
        return manager;
    }

    private void init() {
        Logger.p("init ");
        final IntentFilter bondFilter = new IntentFilter(BluetoothDevice.ACTION_BOND_STATE_CHANGED);
        bondFilter.addAction(BluetoothDevice.ACTION_ACL_CONNECTED);
        bondFilter.addAction(BluetoothDevice.ACTION_ACL_DISCONNECTED);
        Config.getApplication().registerReceiver(mBondStateBroadcastReceiver, bondFilter);
    }

    private IBondStateListener mBondStateListener;

    private final BroadcastReceiver mBondStateBroadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(final Context context, final Intent intent) {

            final BluetoothDevice tempDevice = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
            String action = intent.getAction();
            Logger.p("onReceive mac is " + tempDevice.getAddress() + ";action=" + action);
            if (action.equals(BluetoothDevice.ACTION_ACL_CONNECTED)) {
                Logger.p("onReceive ACTION_ACL_CONNECTED ");
            } else if (action.equals(BluetoothDevice.ACTION_ACL_DISCONNECTED)) {
                Logger.p("onReceive ACTION_ACL_DISCONNECTED ");
            } else if (action.equals(BluetoothDevice.ACTION_BOND_STATE_CHANGED)) {
                final int bondState = intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, -1);
                Logger.p("onReceive bondState is " + bondState);
                if (bondState == BluetoothDevice.BOND_BONDED) {
                    stopBondTimeOut();
                    Logger.p("createBond success, mac is" + tempDevice.getAddress());
                    if (tempDevice.getAddress().equals(mMacAddress)) {
                        if (mBondStateListener != null) {
                            mBondStateListener.onBonded(tempDevice.getAddress());
                            mBondStateListener = null;
                        }
                        connectIfBonded(tempDevice);
                    }
                }
            }

        }
    };

    /**
     * 查看BluetoothInputDevice源码，connect(BluetoothDevice device)该方法可以连接HID设备，但是查看BluetoothInputDevice这个类
     * 是隐藏类，无法直接使用，必须先通过BluetoothProfile.ServiceListener回调得到BluetoothInputDevice，然后再反射connect方法连接
     */
    private BluetoothProfile.ServiceListener serviceListener = new BluetoothProfile.ServiceListener() {
        @Override
        public void onServiceConnected(int profile, BluetoothProfile proxy) {
            //BluetoothProfile proxy这个已经是BluetoothInputDevice类型了
            Logger.p("[onServiceConnected] profile=" + profile);

            int inputProfile = getInputDeviceHiddenConstant();
            Logger.p("[onServiceConnected] getInputDeviceHiddenConstant=" + inputProfile);
            try {
                if (profile == inputProfile) {
                    if (mBluetoothDevice != null) {
                        //得到BluetoothInputDevice然后反射connect连接设备
                        Logger.p("[onServiceConnected] getMethod(\"connect\")=" + inputProfile);
                        Method method = proxy.getClass().getMethod("connect",
                                new Class[]{BluetoothDevice.class});
                        method.invoke(proxy, mBluetoothDevice);
                    }
                }
            } catch (Exception e) {
                Logger.e("[onServiceConnected] " + e.getMessage());
            }
        }

        @Override
        public void onServiceDisconnected(int profile) {
            Logger.p("[onServiceDisconnected] profile=" + profile);
        }
    };

    public void connect(String macAddress) {
        Logger.p("[connect] start, address=" + macAddress);
        mMacAddress = macAddress;
        BluetoothDevice bondedDevice = getBondedDevice(macAddress);
        if (bondedDevice != null) {
            Logger.p("[connect] has bonded.");
            connectIfBonded(bondedDevice);
        } else {
            Logger.p("[connect] not bonded.");
            createBond(macAddress);
        }


    }

    public void connect(BluetoothDevice bluetoothDevice, IBondStateListener bondStateListener) {
        Logger.p("[connect1] start, address=" + bluetoothDevice.getAddress());
        mMacAddress = bluetoothDevice.getAddress();
        mBondStateListener = bondStateListener;
        Logger.p("[connect1] create bond.");
        bluetoothDevice.createBond();
    }

    private BluetoothDevice getBondedDevice(String macAddress) {
        BluetoothDevice bondedDevice = null;
        Set<BluetoothDevice> bondedDevices = BluetoothAdapter.getDefaultAdapter().getBondedDevices();
        for (BluetoothDevice device : bondedDevices) {
            if (device.getAddress().equals(macAddress)) {
                bondedDevice = device;
                break;
            }
        }
        return bondedDevice;
    }

    private void createBond(String macAddress) {
        BluetoothManager manager = (BluetoothManager) CommonUtils.getAppContext().getSystemService(Context.BLUETOOTH_SERVICE);
        List<BluetoothDevice> deviceList = manager.getConnectedDevices(BluetoothProfile.GATT);
        if (deviceList == null || deviceList.size() == 0) {
            Logger.p("[createBond] deviceList is null");
            return;
        }
        for (BluetoothDevice device : deviceList) {
            if (macAddress.equals(device.getAddress())) {
                boolean result = device.createBond();
                Logger.p("[createBond] to create bond. result = " + result);
                startBondTimeOut(device);
                break;
            }
        }
    }

    private void startBondTimeOut(final BluetoothDevice device) {
        mDelayHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                Logger.p("[startBondTimeOut] after create bond.not receive broadcast");
                BluetoothDevice temp = getBondedDevice(mMacAddress);
                if (temp == null) {
                    Logger.p("[startBondTimeOut] retry createBond.");
                    device.createBond();
                } else {
                    Logger.p("[startBondTimeOut] check bonded status is true");
                    connectIfBonded(temp);
                }
            }
        }, 10 * 1000);
    }

    private void stopBondTimeOut() {
        mDelayHandler.removeCallbacksAndMessages(null);
    }

    /**
     * 连接设备
     */
    private void connectIfBonded(final BluetoothDevice device) {
        Logger.p("[connectIfBonded] mac is " + device.getAddress());
        mBluetoothDevice = device;
        try {
            BluetoothAdapter.getDefaultAdapter().getProfileProxy(Config.getApplication(),
                    serviceListener, getInputDeviceHiddenConstant());
        } catch (Exception e) {
            Logger.e("[connectIfBonded] " + e.getMessage());
        }
    }

    /**
     * 获取BluetoothProfile中hid的profile，"INPUT_DEVICE"类型隐藏，需反射获取
     *
     * @return
     */
    @SuppressLint("NewApi")
    private static int getInputDeviceHiddenConstant() {
        Class<BluetoothProfile> clazz = BluetoothProfile.class;
        for (Field f : clazz.getFields()) {
            int mod = f.getModifiers();
            if (Modifier.isStatic(mod) && Modifier.isPublic(mod)
                    && Modifier.isFinal(mod)) {
                try {
                    if (f.getName().equals("INPUT_DEVICE")) {
                        return f.getInt(null);
                    }
                } catch (Exception e) {
                    Logger.e("[getInputDeviceHiddenConstant] " + e.getMessage());
                }
            }
        }
        return -1;
    }
}
