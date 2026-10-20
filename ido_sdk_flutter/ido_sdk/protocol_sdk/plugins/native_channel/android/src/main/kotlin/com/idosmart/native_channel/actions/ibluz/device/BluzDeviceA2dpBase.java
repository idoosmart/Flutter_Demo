package com.idosmart.native_channel.actions.ibluz.device;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothProfile;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Handler;
import android.os.Parcelable;
import android.util.Log;


import com.idosmart.native_channel.actions.ibluz.factory.BluzDeviceFactory;
import com.idosmart.native_channel.common.utils.BroadcastReceiverCompat;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

@SuppressLint("MissingPermission")
public abstract class BluzDeviceA2dpBase implements IBluzDeviceA2dp{
    private static final String TAG = "BluzDeviceA2dpBase";

    private static final int A2DP_CONNECT_TIMEOUT = 15000;

    protected Context mContext = null;
    protected BluetoothAdapter mBluetoothAdapter;
    protected BluetoothDevice mBluetoothDevice = null;
    protected BluetoothDevice mDeviceCandidate = null;
    protected BluetoothDevice mDeviceConnected = null;
    protected IA2dpListener mListener = null;
    protected boolean mProfileWaitForDataConnect = false;
    protected boolean mAutoConnect = true;
    /*
     * set true if disconnect; set false if user connect or disconnect silence timeout
     */
    protected boolean mDisconnectSilence = false;

    private Handler mHandler = new Handler();

    protected abstract boolean isA2dpConnected();
    public abstract BluetoothDevice getConnectedDevice();

    private BroadcastReceiver mBluetoothReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (BluetoothDevice.ACTION_BOND_STATE_CHANGED.equals(action)) {
                BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                int state = intent.getIntExtra(BluetoothDevice.EXTRA_BOND_STATE, BluetoothAdapter.ERROR);
                Log.v(TAG, "Bluetooth bond state changed:" + state);
                if (state == BluetoothDevice.BOND_BONDED) {
                    if (device != null && mBluetoothDevice != null && device.equals(mBluetoothDevice)) {
                        connectProfiles();
                    }
                }

                mDeviceCandidate = device;
                updateA2dpConnectionState(state);
            } else if (BluetoothDevice.ACTION_PAIRING_REQUEST.equals(action)) {
                BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                int type = intent.getIntExtra(BluetoothDevice.EXTRA_PAIRING_VARIANT, BluetoothDevice.ERROR);
                Log.i(TAG, "pair type:" + type);

                if (type == BluetoothDevice.PAIRING_VARIANT_PASSKEY_CONFIRMATION || type == getPairingVariantConsentHiddenConstant()) {
                    try {
                        Method setPairingConfirmation = device.getClass().getMethod("setPairingConfirmation", boolean.class);
                        setPairingConfirmation.invoke(device, true);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                }
            } else if (BluetoothDevice.ACTION_UUID.equals(action)) {
                Parcelable[] uuids = intent.getParcelableArrayExtra(BluetoothDevice.EXTRA_UUID);
                for (int i = 0; i < uuids.length; i++) {
                    Log.i(TAG, "uuid:" + uuids[i].toString());
                }
            }
        }
    };

    private Runnable mA2dpCallback = new Runnable() {
        @Override
        public void run() {
            if (!isA2dpConnected()) {
                Log.i(TAG, "a2dp callback timeout");
                connectA2dpFail();
            }
        }
    };

    // ----------------------------------

    public BluzDeviceA2dpBase(Context context) {
        Log.i(TAG, "Create");
        mContext = context;
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        registerReceiver();
    }

    protected void registerReceiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(BluetoothDevice.ACTION_BOND_STATE_CHANGED);
        filter.addAction(BluetoothDevice.ACTION_PAIRING_REQUEST);
        // for test only
        // filter.addAction(BluetoothDevice.ACTION_UUID);
        BroadcastReceiverCompat.register(mContext, mBluetoothReceiver, filter);
    }

    protected void unregisterReceiver() {
        mContext.unregisterReceiver(mBluetoothReceiver);
    }

    protected void connect() {
        if (mListener != null) {
            mListener.connect();
        }
    }

    /**
     * A2dp and SPP/BLE
     *
     */
    private void connectProfiles() {
        Log.v(TAG, "connectProfiles");
        mDisconnectSilence = false;
        if (isA2dpConnected()) {
            connectWithProfileConnected(getConnectedDevice());
        } else {
            if (!connectA2DP()) {
                connectA2dpFail();
            }
        }
    }

    protected boolean connectA2DP() {
        mHandler.removeCallbacks(mA2dpCallback);
        mHandler.postDelayed(mA2dpCallback, A2DP_CONNECT_TIMEOUT);
        return true;
    }

    protected void connectA2dpFail() {
        mHandler.removeCallbacks(mA2dpCallback);
        updateConnectionState(BluzDeviceFactory.ConnectionState.A2DP_FAILURE);
        mBluetoothDevice = null;
    }

    protected void updateConnectionState(int state) {
        if (mListener != null) {
            mListener.updateConnectionState(mDeviceCandidate, state);
        }
    }

    protected void updateA2dpConnectionState(int state) {
        if (state == BluetoothProfile.STATE_CONNECTED) {
            mHandler.removeCallbacks(mA2dpCallback);
            updateConnectionState(BluzDeviceFactory.ConnectionState.A2DP_CONNECTED);
        } else if (state == BluetoothProfile.STATE_CONNECTING) {
            updateConnectionState(BluzDeviceFactory.ConnectionState.A2DP_CONNECTING);
        } else if (state == BluetoothProfile.STATE_DISCONNECTED || state == BluetoothProfile.STATE_DISCONNECTING) {
            if (mListener != null && (mBluetoothDevice == null || mBluetoothDevice != null && mBluetoothDevice.equals(mDeviceCandidate))) {
                mListener.disconnect();
            }
            mBluetoothDevice = null;
            updateConnectionState(BluzDeviceFactory.ConnectionState.A2DP_DISCONNECTED);
        } else if (state == BluetoothDevice.BOND_BONDING) {
            updateConnectionState(BluzDeviceFactory.ConnectionState.A2DP_PAIRING);
        }
    }

    public static int getPairingVariantConsentHiddenConstant() {
        Class<BluetoothDevice> clazz = BluetoothDevice.class;
        for (Field f : clazz.getFields()) {
            int mod = f.getModifiers();
            if (Modifier.isStatic(mod) && Modifier.isPublic(mod) && Modifier.isFinal(mod)) {
                try {
                    if (f.getName().equals("PAIRING_VARIANT_CONSENT")) {
                        return f.getInt(null);
                    }
                } catch (Exception e) {
                    Log.e(TAG, e.toString());
                }
            }
        }
        return -1;
    }

    // 除ota外，其余app之前均使用反射的方式获取绑定。这个方法不稳定，容易产生不兼容的问题，因此统一改为以下方法
    private void pair() {
        Log.v(TAG, "pair()");
        try {
            mBluetoothAdapter.cancelDiscovery();
            mBluetoothDevice.createBond();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void readyConnect() {
        synchronized (this) {
            if (!mProfileWaitForDataConnect || mDisconnectSilence) {
                Log.i(TAG, "readyConnect: !mProfileWaitForDataConnect || mDisconnectSilenc");
                return;
            }

            BluetoothDevice device = mDeviceConnected;
            if (device == null) {
                Log.i(TAG, "readyConnect: device == null");
                return;
            }
            Log.i(TAG, "readyConnect: connect mBluetoothDevice != null "+(mBluetoothDevice != null)+ "device.equals(mBluetoothDevice)"+device.equals(mBluetoothDevice));
            if (device != null && mBluetoothDevice != null && device.equals(mBluetoothDevice)) {
                Log.i(TAG, "readyConnect: if device.equals(mBluetoothDevice)");
                connect();
            } else if (device != null && mBluetoothDevice == null) {
                Log.i(TAG, "readyConnect: else if  ");
                if (mAutoConnect)
                    connect();
            }
            Log.i(TAG, "readyConnect: finish");
            mProfileWaitForDataConnect = false;
        }
    }

    public void setAutoConnectDataChanel(boolean enable){
        mAutoConnect = enable;
    }

    // IBluzDeviceA2dp

    public void connect(BluetoothDevice device) {
        if (device == null) {
            Log.i(TAG, "connect device null");
            return;
        }

        mBluetoothDevice = device;
        int bondState = mBluetoothDevice.getBondState();
        if (bondState == BluetoothDevice.BOND_NONE) {
            pair();
        } else if (bondState == BluetoothDevice.BOND_BONDED || bondState == BluetoothDevice.BOND_BONDING) {
            /* fix when a2dp fail to connect, the state is not changed properly */
            if (mDeviceCandidate == null) {
                mDeviceCandidate = mBluetoothDevice;
            }
            connectProfiles();
        }
    }

    public void release() {
        mHandler.removeCallbacks(mA2dpCallback);
        unregisterReceiver();
    }

    public void setListener(IA2dpListener listener) {
        mListener = listener;
    }

}
