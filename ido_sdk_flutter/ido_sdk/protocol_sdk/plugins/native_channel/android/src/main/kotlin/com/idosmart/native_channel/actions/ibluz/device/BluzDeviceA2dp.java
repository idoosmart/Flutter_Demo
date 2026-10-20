package com.idosmart.native_channel.actions.ibluz.device;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothA2dp;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothHeadset;
import android.bluetooth.BluetoothProfile;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Handler;
import android.util.Log;

import com.idosmart.native_channel.common.utils.BroadcastReceiverCompat;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.List;

@SuppressLint("MissingPermission")
public class BluzDeviceA2dp extends BluzDeviceA2dpBase{
    private static final String TAG = "BluzDeviceA2dp";
    public static final String ACTION_CONNECTION_STATE_CHANGED = "com.actions.ibluz.device.state_change";

    // cannot initialize here, may override the value assigned during in parent constructor
    private Method mMethodConnect;
    private Method mMethodDisconnect;
    private Method mMethodHfpDisconnect;
    private Method mMethodInputDisconnect;
    private Method mMethodRemoveBound;
    private BluetoothA2dp mService;
    private BluetoothHeadset mHfpService;
    private BluetoothProfile mInputService;
    private boolean mRemoveBound;

    private BroadcastReceiver mBluetoothReceiver;

    private Handler mHandler = new Handler();
    private Runnable mHfpTimeout = new Runnable() {

        @Override
        public void run() {
            Log.i(TAG, "timeout, readyConnect");
            readyConnect();
        }
    };

    public BluzDeviceA2dp(Context context, boolean removeBound) {
        super(context);
        mRemoveBound = removeBound;
        Log.i(TAG, "Create");
        getProfileProxy();
    }

    private void getProfileProxy() {
        mBluetoothAdapter.getProfileProxy(mContext, new BluetoothProfile.ServiceListener() {

            @Override
            public void onServiceDisconnected(int profile) {
                Log.i(TAG, "Bluetooth service disconnected");
            }

            @Override
            public void onServiceConnected(int profile, BluetoothProfile proxy) {
                Log.i(TAG, "Bluetooth service connected, profile:" + profile);
                mService = (BluetoothA2dp) proxy;
                initMethod();
                // in order to service is been connected after the a2dp
                // auto-connect
                if (mAutoConnect)
                    connect();
            }
        }, BluetoothProfile.A2DP);

        mBluetoothAdapter.getProfileProxy(mContext, new BluetoothProfile.ServiceListener() {

            @Override
            public void onServiceDisconnected(int profile) {
                Log.i(TAG, "Bluetooth hfp service disconnected");
            }

            @Override
            public void onServiceConnected(int profile, BluetoothProfile proxy) {
                Log.i(TAG, "Bluetooth hfp service connected, profile:" + profile);
                mHfpService = (BluetoothHeadset) proxy;
                initMethodHfp();
            }
        }, BluetoothProfile.HEADSET);

        mBluetoothAdapter.getProfileProxy(mContext, new BluetoothProfile.ServiceListener() {

            @Override
            public void onServiceDisconnected(int profile) {
                Log.i(TAG, "Bluetooth input service disconnected");
            }

            @Override
            public void onServiceConnected(int profile, BluetoothProfile proxy) {
                Log.i(TAG, "Bluetooth input service connected, profile:" + profile);
                mInputService = proxy;
                initMethodInput();
            }
        }, getInputDeviceHiddenConstant());
    }

    private void closeProfileProxy() {
        if (mService != null) {
            mBluetoothAdapter.closeProfileProxy(BluetoothProfile.A2DP, mService);
        }
        if (mHfpService != null) {
            mBluetoothAdapter.closeProfileProxy(BluetoothProfile.HEADSET, mHfpService);
        }
        if (mInputService != null) {
            mBluetoothAdapter.closeProfileProxy(getInputDeviceHiddenConstant(),mInputService);
        }
    }

    // ------------------------------ init method ---------------------------------- //

    private void initMethod() {
        try {
            mMethodConnect = mService.getClass().getMethod("connect", BluetoothDevice.class);
            mMethodDisconnect = mService.getClass().getMethod("disconnect", BluetoothDevice.class);
            mMethodRemoveBound = BluetoothDevice.class.getMethod("removeBond");
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
    }

    private void initMethodHfp() {
        try {
            mMethodHfpDisconnect = mHfpService.getClass().getMethod("disconnect", BluetoothDevice.class);
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
    }

    private void initMethodInput() {
        try {
            mMethodInputDisconnect =  Class.forName("android.bluetooth.BluetoothInputDevice").getMethod("disconnect", BluetoothDevice.class);
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static int getInputDeviceHiddenConstant() {
        Class<BluetoothProfile> clazz = BluetoothProfile.class;
        for (Field f : clazz.getFields()) {
            int mod = f.getModifiers();
            if (Modifier.isStatic(mod) && Modifier.isPublic(mod) && Modifier.isFinal(mod)) {
                try {
                    if (f.getName().equals("INPUT_DEVICE")) {
                        return f.getInt(null);
                    }
                } catch (Exception e) {
                    Log.e(TAG, e.toString());
                }
            }
        }
        return -1;
    }

    // ------------------------------ registerReceiver ---------------------------------- //

    protected void registerReceiver() {
        super.registerReceiver();
        /* called in Constructor by parent class, so it must be initialized right before call */
        mBluetoothReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String action = intent.getAction();

                if (BluetoothA2dp.ACTION_CONNECTION_STATE_CHANGED.equals(action)) {
                    BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                    int state = intent.getIntExtra(BluetoothProfile.EXTRA_STATE, BluetoothAdapter.ERROR);
                    int statePre = intent.getIntExtra(BluetoothProfile.EXTRA_PREVIOUS_STATE, BluetoothAdapter.ERROR);
                    Log.w(TAG, "Bluetooth A2dp mService.getConnectedA2dpDevices()" + getConnectedDevice());
                    Log.v(TAG, "Bluetooth A2dp connection state changed! preState = " + statePre + "=> state = " + state);
                    Log.v(TAG, "Bluetooth A2dp mService.getConnectionState(device)" + mService.getConnectionState(device));
                    mDeviceCandidate = device;
                    if (state != statePre) {
                        updateA2dpConnectionState(state);
                    }

                    if (state == BluetoothProfile.STATE_CONNECTED) {
                        Log.i(TAG, "Bluetooth A2dp connectWithProfileConnected ");
                        connectWithProfileConnected(device,true);
                    } else if (state == BluetoothProfile.STATE_DISCONNECTED) {
                        Log.i(TAG, "Bluetooth A2dp STATE_DISCONNECTED ");
                        mDeviceConnected = null;
                    }
                } else if (BluetoothHeadset.ACTION_CONNECTION_STATE_CHANGED.equals(action)) {
                    BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                    int state = intent.getIntExtra(BluetoothProfile.EXTRA_STATE, BluetoothAdapter.ERROR);
                    int statePre = intent.getIntExtra(BluetoothProfile.EXTRA_PREVIOUS_STATE, BluetoothAdapter.ERROR);

                    Log.w(TAG, "Bluetooth Headset mService.getConnectedA2dpDevices()" + getConnectedDevice());
                    Log.v(TAG, "BluetoothHeadset connection state changed! state = " + state + "<=" + statePre);
                    if (state == BluetoothProfile.STATE_CONNECTED) {
                        Log.i(TAG, "BluetoothHeadset connectWithProfileConnected ");
                        connectWithProfileConnected(device);
                    }
                } else if (BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED.equals(action)) {
                    BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                    int state = intent.getIntExtra(BluetoothAdapter.EXTRA_CONNECTION_STATE, BluetoothAdapter.ERROR);
                    int statePre = intent.getIntExtra(BluetoothAdapter.EXTRA_PREVIOUS_CONNECTION_STATE, BluetoothAdapter.ERROR);
                    // if (state == BluetoothProfile.STATE_CONNECTED) {
                    // Log.i(TAG, "BluetoothAdapter connectWithProfileConnected ");
                    // connectWithProfileConnected(device);
                    // }
                    // Log.v(TAG, "BluetoothAdapter connection state changed! state = " + state + "<=" + statePre);
                    // Log.v(TAG, "BluetoothAdapter mService.getConnectionState(device)"+mService.getConnectionState(device));
                } else if ( BluzDeviceA2dp.ACTION_CONNECTION_STATE_CHANGED.equals(action)) {
                    BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                    int state = intent.getIntExtra(BluetoothProfile.EXTRA_STATE, BluetoothAdapter.ERROR);
                    Log.w(TAG, "Bluetooth A2dp mService.getConnectedA2dpDevices()" + getConnectedDevice());
                    mDeviceCandidate = device;
                    updateA2dpConnectionState(state);

                    if (state == BluetoothProfile.STATE_CONNECTED) {
                        Log.i(TAG, "Bluetooth A2dp connectWithProfileConnected ");
                        connectWithProfileConnected(device,true);
                    } else if (state == BluetoothProfile.STATE_DISCONNECTED) {
                        Log.i(TAG, "Bluetooth A2dp STATE_DISCONNECTED ");
                        mDeviceConnected = null;
                    }
                }
            }
        };

        IntentFilter filter = new IntentFilter();
        filter.addAction(BluetoothA2dp.ACTION_CONNECTION_STATE_CHANGED);
        filter.addAction(BluetoothHeadset.ACTION_CONNECTION_STATE_CHANGED);
        filter.addAction(BluetoothAdapter.ACTION_CONNECTION_STATE_CHANGED);
        filter.addAction(BluzDeviceA2dp.ACTION_CONNECTION_STATE_CHANGED);
        BroadcastReceiverCompat.register(mContext, mBluetoothReceiver, filter);
    }

    @Override
    protected void unregisterReceiver() {
        super.unregisterReceiver();
        mContext.unregisterReceiver(mBluetoothReceiver);
        closeProfileProxy();
    }

    // --------------------------------------------------------------------------------- //

    protected boolean connectA2DP() {
        super.connectA2DP();
        if (mService == null) {
            return false;
        }
        List<BluetoothDevice> sinks = mService.getConnectedDevices();
        Log.v(TAG, "connectA2DP");

        boolean result = false;
        try {
            if (sinks != null) {
                for (BluetoothDevice sink : sinks) {
                    Log.v(TAG, "connectA2DP mMethodDisconnect sink = " + sink.getName());
                    disconnect(sink);
                }
            }
            Log.v(TAG, "connectA2DP mMethodConnect device = " + mBluetoothDevice.getName());
            result = (Boolean) mMethodConnect.invoke(mService, mBluetoothDevice);
            Log.v(TAG, "connectA2DP mMethodConnect return = " + result);
        } catch (Exception e) {
            Log.e(TAG, "connectA2DP:" + e);
        }
        return result;
    }

    // --------------------------------------------------------------------------------- //

    @Override
    protected boolean isA2dpConnected() {
        return mService.getConnectionState(mBluetoothDevice) == BluetoothProfile.STATE_CONNECTED;
    }

    @Override
    public void connectWithProfileConnected(BluetoothDevice device) {
        connectWithProfileConnected(device, false);
    }

    public void connectWithProfileConnected(BluetoothDevice device, boolean isA2DP) {
        if (mService == null || mHfpService == null) {
            Log.e(TAG, "connectWithProfileConnected service not ready");
            return;
        }
        int connectionState = mService.getConnectionState(device);
        Log.w(TAG, "connectWithProfileConnected mService.getConnectionState" + connectionState);
        Log.w(TAG, "connectWithProfileConnected mService.getConnectedA2dpDevices()" + getConnectedDevice());

        if (connectionState == BluetoothProfile.STATE_CONNECTED || connectionState == BluetoothProfile.STATE_CONNECTING
                || (Build.MODEL.contains("Coolpad 8690_T00"))) {
            // to fix Coolpad 8690_T00 sometimes connectionState mismatch
            Log.w(TAG, "connectWithProfileConnected " + Build.MODEL);
            Log.w(TAG, "connectWithProfileConnected mService.getConnectionState" + connectionState);
            Log.w(TAG, "connectWithProfileConnected mService.getConnectedA2dpDevices()" + getConnectedDevice());
            mProfileWaitForDataConnect = true;
            mDeviceConnected = device;

            connectionState = mHfpService.getConnectionState(device);

            Log.w(TAG, "connectWithProfileConnected mHfpService.getConnectionState" + connectionState);
            if (connectionState == BluetoothProfile.STATE_CONNECTED || connectionState == BluetoothProfile.STATE_CONNECTING) {
                mHandler.removeCallbacks(mHfpTimeout);
                Log.w(TAG, "if readyConnect()");
                if (Build.MODEL.contains("Coolpad 8690_T00")) {
                    mHandler.postDelayed(mHfpTimeout, 1000);
                } else {
                    readyConnect();
                }

            } else {
                Log.w(TAG, "else mHandler.postDelayed(mHfpTimeout, 2000);");
                mHandler.postDelayed(mHfpTimeout, 2000);
            }
        } else {
            if (isA2DP) {
                connectA2dpFail();
            }
            Log.w(TAG, "connectWithProfileConnected connectionState abnormal:" + connectionState);
        }
    }

    @Override
    public void disconnect(BluetoothDevice device) {
        try {
            if (device == null){
                Log.d(TAG, "disconnect device null return");
                return;
            }
            mDisconnectSilence = true;
            mDeviceConnected = null;

            if (mInputService != null)
                mMethodInputDisconnect.invoke(mInputService, device);
            if (mHfpService != null)
                mMethodHfpDisconnect.invoke(mHfpService, device);
            if (mService != null) {
                mMethodDisconnect.invoke(mService, device);
                if (mRemoveBound && mMethodRemoveBound!= null) {
                    boolean ret = (Boolean) mMethodRemoveBound.invoke(device);
                    Log.d(TAG, "removeBound return " + ret);
                }
            }
            Thread.sleep(2000);
            mHandler.postDelayed(new Runnable() {

                @Override
                public void run() {
                    mDisconnectSilence = false;
                }
            }, 5000);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public BluetoothDevice getConnectedDevice() {
        if (mService == null) {
            return null;
        }
        List<BluetoothDevice> list = null;
        list = mService.getConnectedDevices();
        if (list != null && list.size() > 0) {
            Log.v(TAG, "class getConnectedDevice " + list.get(0));
            return list.get(0);
        }
        return null;
    }
}
