package com.idosmart.native_channel.actions.ibluz.device;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothProfile;
import android.content.Context;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.util.Log;


import com.idosmart.native_channel.actions.ibluz.device.ibluz.IBluetooth;
import com.idosmart.native_channel.actions.ibluz.device.ibluz.IBluetoothA2dp;

import java.lang.reflect.Method;

public class BluzDeviceA2dpCompat extends BluzDeviceA2dpBase{

    private static final String TAG = "BluzDeviceA2dpCompat";

    private static final int STATE_DISCONNECTED = 0;
    private static final int STATE_CONNECTED = 2;

    private static final int MSG_CONNECTION_PRE_HONEYCOMB = 0;
    private static final int CONNECTION_PERIOD = 1500;

    private IBluetoothA2dp mIBluetoothA2dp = null;
    private IBluetooth mIBluetooth = null;
    private int mConnectionStatePre = STATE_DISCONNECTED;

    @SuppressLint("HandlerLeak")
    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case MSG_CONNECTION_PRE_HONEYCOMB:
                    updateConnection();
                    mHandler.sendEmptyMessageDelayed(MSG_CONNECTION_PRE_HONEYCOMB, CONNECTION_PERIOD);
                    break;

                default:
                    break;
            }
        }
    };

    public BluzDeviceA2dpCompat(Context context) {
        super(context);
        initMethod();
        initHandler();
    }

    private void initMethod() {
        initA2dpMethod();
        initHeadsetMethod();
    }

    private void initHandler() {
        mHandler.removeMessages(MSG_CONNECTION_PRE_HONEYCOMB);
        mHandler.sendEmptyMessage(MSG_CONNECTION_PRE_HONEYCOMB);
    }

    private void initA2dpMethod() {
        try {
            Class serviceManager = Class.forName("android.os.ServiceManager");
            Method getService = serviceManager.getDeclaredMethod("getService", String.class);
            IBinder iBinder = (IBinder) getService.invoke(null, "bluetooth_a2dp");
            Class iBluetoothA2dp = Class.forName("android.bluetooth.IBluetoothA2dp");
            Class[] declaredClasses = iBluetoothA2dp.getDeclaredClasses();
            Class c = declaredClasses[0];
            Method asInterface = c.getDeclaredMethod("asInterface", IBinder.class);
            asInterface.setAccessible(true);
            mIBluetoothA2dp = (IBluetoothA2dp) asInterface.invoke(null, iBinder);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(TAG, "initA2dpMethod:" + e);
        }
    }

    private void initHeadsetMethod() {
        try {
            Class serviceManager = Class.forName("android.os.ServiceManager");
            Method getService = serviceManager.getDeclaredMethod("getService", String.class);
            IBinder iBinder = (IBinder) getService.invoke(null, "bluetooth");
            Class iBluetooth = Class.forName("android.bluetooth.IBluetooth");
            Class[] declaredClasses = iBluetooth.getDeclaredClasses();
            Class c = declaredClasses[0];
            Method asInterface = c.getDeclaredMethod("asInterface", IBinder.class);
            asInterface.setAccessible(true);
            mIBluetooth = (IBluetooth) asInterface.invoke(null, iBinder);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(TAG, "initHeadsetMethod:" + e);
        }
    }

    // ------------------------------ Handler ---------------------------------- //

    private void updateConnection() {
        int state = STATE_DISCONNECTED;
        try {
            BluetoothDevice[] devices = mIBluetoothA2dp.getConnectedSinks();
            Log.i(TAG, "updateConnection: "+devices);
            if (devices != null && devices.length > 0) {
                for (BluetoothDevice device : devices) {
                    mDeviceCandidate = device;

                    state = STATE_CONNECTED;
                    if (state != mConnectionStatePre) {
                        mConnectionStatePre = state;
                        updateA2dpConnectionState(state);
                        connectWithProfileConnected(device);
                    }
                }
            }
        } catch (Exception e) {
            Log.e(TAG, "updateConnection:" + e);
        }
        if (state != mConnectionStatePre) {
            mConnectionStatePre = state;
            updateA2dpConnectionState(state);
        }
    }

    // -------------------------------------------------------------------------- //
    @Override
    protected boolean isA2dpConnected() {
        boolean connected = false;
        try {
            int state =   mIBluetoothA2dp.getSinkState(mBluetoothDevice);
            if (state == BluetoothProfile.STATE_CONNECTED || state == BluetoothProfile.STATE_CONNECTING) {
                connected = true;
            }
        } catch (Exception e) {
            Log.e(TAG, "isA2dpConnected:" + e);
        }
        return connected;
    }

    @Override
    public void connectWithProfileConnected(BluetoothDevice device) {
        mProfileWaitForDataConnect = true;
        mDeviceConnected = device;
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                synchronized (this) {
                    Log.i(TAG, "delay, readyConnect");
                    readyConnect();
                }
            }
        }, 2000);
    }

    @Override
    public void disconnect(BluetoothDevice device) {
        try {
            mDisconnectSilence = true;
            mIBluetooth.disconnectHeadset(device.getAddress());
            mIBluetoothA2dp.disconnectSink(device);
            Thread.sleep(2000);
            mHandler.postDelayed(new Runnable() {

                @Override
                public void run() {
                    mDisconnectSilence = false;
                }
            }, 5000);
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(TAG, "disconnect:" + e);
        }
    }

    @Override
    public BluetoothDevice getConnectedDevice() {
        try {
            BluetoothDevice[] devices = mIBluetoothA2dp.getConnectedSinks();
            if (devices != null && devices.length > 0) {
                return devices[0];
            }
        } catch (Exception e) {
            Log.e(TAG, "getConnectedDevice:" + e);
        }
        return null;
    }

    // ------------------------------------------------------------------------------ //
    @SuppressLint("MissingPermission")
    @Override
    protected boolean connectA2DP() {
        super.connectA2DP();

        boolean result = false;
        try {
            int state =   mIBluetoothA2dp.getSinkState(mBluetoothDevice);
            switch (state) {
                case BluetoothProfile.STATE_CONNECTED:
                case BluetoothProfile.STATE_CONNECTING:
                    result = true;
                    break;

                case BluetoothProfile.STATE_DISCONNECTED:
                case BluetoothProfile.STATE_DISCONNECTING:
                    Log.v(TAG, "connectA2DP mMethodConnect device = " + mBluetoothDevice.getName());
                    result =  mIBluetoothA2dp.connectSink(mBluetoothDevice);
                    Log.v(TAG, "connectA2DP mMethodConnect return = " + result);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @Override
    public void release() {
        super.release();
        mHandler.removeMessages(MSG_CONNECTION_PRE_HONEYCOMB);
    }
}
