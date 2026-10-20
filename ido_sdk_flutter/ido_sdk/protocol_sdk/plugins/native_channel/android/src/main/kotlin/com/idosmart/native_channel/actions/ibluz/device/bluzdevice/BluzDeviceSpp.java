package com.idosmart.native_channel.actions.ibluz.device.bluzdevice;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Handler;
import android.util.Log;


import com.idosmart.native_channel.actions.ibluz.factory.BluzDeviceFactory;
import com.idosmart.native_channel.actions.ibluz.util.Utils;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class BluzDeviceSpp extends BluzDeviceBase {
    private String TAG = "BluzDeviceSpp";

    private static final int SPP_CONNECT_TIMEOUT = 10000;

    private static final int SPP_RETRY_MAX_TIMES = 20;

    private BluetoothSocket mBluetoothSocket = null;
    private DataOutputStream mOutputStream = null;
    private DataInputStream mInputStream = null;
    private boolean mAutoConnecting = false;

    private UUID mUUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");

    private Handler mHandler = new Handler();

    private ConnectionTask mConnectionTask = null;

    /* indicate whether any activity poped while data connect */
    private boolean mConnectPopActivity = false;

    private int reConnectTime = 0; // 限制socket重试连接次数
    private static final int RECONNECT_MAX_TIME = 10;

    private int mReTryTime = 0;


    // --------------------------------- runable ------------------------------------------- //
    private Runnable mSppCallback = new Runnable() {
        @Override
        public synchronized void run() {
            if (mDeviceConnected == null) {
                if (!Utils.isAppForeground(mContext)) {
                    /* FIXME when data connect, it pops a confirm activity, like Lenovo S939 */
                    Log.i(TAG, "mHandler.postDelayed 2");
                    mHandler.postDelayed(mSppCallback, SPP_CONNECT_TIMEOUT);
                    return;
                } else if (mConnectPopActivity) {
                    /* if activity pop, the connect() moment is only triggered by the user behavior, so the timeout mechanism should change to make sense */
                    mConnectPopActivity = false;
                    Log.i(TAG, "mHandler.postDelayed 3");
                    mHandler.postDelayed(mSppCallback, SPP_CONNECT_TIMEOUT);
                    return;
                }

                if (mConnectionTask != null) {
                    mConnectionTask.cancel(true);
                }
                Log.i(TAG, "mSppCallback");
                connectSppFail();
            }
        }
    };

    // ------------------------------------------------------------------------------------- //
    public BluzDeviceSpp(Context context) {
        super(context, false, false);
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        mReTryTime = 0;
    }

    private void connectSppFail() {
        Log.i(TAG, "SPP connect fail");
        mHandler.removeCallbacks(mSppCallback);
        disconnect();
        updateConnectionState(BluzDeviceFactory.ConnectionState.SPP_FAILURE);
        mBluetoothDevice = null;
        Log.e(TAG, "fail1");
        mServiceConnectListener.onServiceConnectFail();
    }

    private synchronized void connectSppSuccess() {
        try {
            cancelDiscovery();
            Log.i(TAG, "SPP connected");
            mDeviceConnected = mBluetoothDevice;
            //	knockDoor();
            updateConnectionState(BluzDeviceFactory.ConnectionState.SPP_CONNECTED);
            if (mConnectListener != null) {
                mConnectListener.onConnectSuccess(mDeviceConnected);
            }
            mHandler.removeCallbacks(mSppCallback);
        } catch (Exception e) {
            disconnect();
            if (mConnectListener != null) {
                mConnectListener.onConnectFail();
            }
        }
    }

    // ------------------------------------- override ---------------------------------------  //
    @Override
    public void setUUID(UUID uuid) {
        this.mUUID = uuid;
    }

    @Override
    public void connect() {
        super.connect();

        if (mBluetoothDevice == null || mAutoConnecting) {
            return ;
        }

        Log.v(TAG, "connectSPPAsync");
        mAutoConnecting = true;
        updateConnectionState(BluzDeviceFactory.ConnectionState.SPP_CONNECTING);
        mConnectionTask = new ConnectionTask();
        mConnectionTask.execute(mBluetoothDevice);

    }

    @SuppressLint("MissingPermission")
    @Override
    public void connectSpp(BluetoothDevice device) {
        if (device == null) {
            mServiceConnectListener.onServiceConnectFail();
            return;
        }
        try {
            mBluetoothSocket = device.createInsecureRfcommSocketToServiceRecord(mUUID);
            mInputStream = new DataInputStream(mBluetoothSocket.getInputStream());
            mOutputStream = new DataOutputStream(mBluetoothSocket.getOutputStream());
            Log.i(TAG, "connectSpp sucess!");
        } catch (IOException e) {
            Log.e(TAG, "socket建立失败" + e);
            try {
                mBluetoothSocket.close();
            } catch (IOException ex) {
                mServiceConnectListener.onServiceConnectFail();
                ex.printStackTrace();
                return;
            }
            mServiceConnectListener.onServiceConnectFail();
            return;
        }

        mHandler.removeCallbacks(mSppCallback);
        int timeout = SPP_CONNECT_TIMEOUT;
        if (Build.MODEL.contains("HTC T328w")) {
            /* FIXME new desire need 13s to connect */
            timeout = 15000;
        }

        mConnectPopActivity = false;
        if (Build.MODEL.contains("Lenovo S939") || Build.MODEL.contains("Lenovo S898t+")) {
            mConnectPopActivity = true;
        }
        Log.i(TAG, "mHandler.postDelayed 1");
        mHandler.postDelayed(mSppCallback, timeout);
        Log.i(TAG, "SPP connecting");
        //In some device like ZTE U930, discovery and connect at the same time may cause IOException: Unable to start Service Discovery which lead to a connection fail.
        mBluetoothAdapter.cancelDiscovery();
        try {
            if (mBluetoothSocket != null) {
                mBluetoothSocket.connect();
                mHandler.removeCallbacks(mSppCallback);
                reConnectTime = 0;
                mServiceConnectListener.onServiceConnected();
            }
        } catch (IOException e) {
            Log.d(TAG + " nick " + mIsStress, "蓝牙连接异常" + e);
            if (mIsStress) {
                try {
                    if (mBluetoothSocket != null) {
                        mBluetoothSocket.close();
                    }
                    disconnect(device);
                    ScheduledExecutorService executor = Executors.newSingleThreadScheduledExecutor();
                    executor.schedule(() -> {
                        mReTryTime++;
                        if (mReTryTime < SPP_RETRY_MAX_TIMES) {
                            mServiceConnectListener.onServiceConnectFail();
                        } else {
                            connectSpp(device);
                        }
                    }, 1, TimeUnit.SECONDS);
                } catch (IOException ex) {
                    Log.e(TAG, "IOE:" + ex);
                    mServiceConnectListener.onServiceConnectFail();
                }
            } else {
                if (reConnectTime == 0) {
                    Timer timer = new Timer();
                    timer.schedule(new TimerTask() {
                        @Override
                        public void run() {
                            Log.i(TAG, "ota，重试");
                            connectSpp(device);
                            reConnectTime ++;
                        }
                    }, 1000);
                } else {
                    Log.i(TAG, "非压测，走失败");
                    mServiceConnectListener.onServiceConnectFail();
                }
            }
        }
    }

    @Override
    public void disconnect() {
        if (mBluetoothSocket != null) {
            try {
                Log.i(TAG, "close");
                if (mInputStream != null) {
                    mInputStream.close();
                }

                if (mOutputStream != null) {
                    mOutputStream.flush();
                    mOutputStream.close();
                }

                mBluetoothSocket.close();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                mBluetoothSocket = null;
            }

            if (mConnectionListener != null && mDeviceConnected != null) {
                mConnectionListener.onDisconnected(mDeviceConnected);
            }
        }
        unPairDevice(mDeviceConnected);
        mDeviceConnected = null;
        mConnecting = false;
    }

    @Override
    public void setUUID(Map<String, UUID> uuids) {

    }

    @Override
    public void write(byte[] buffer) throws Exception {
        Utils.printHexBuffer(TAG, buffer);
        mOutputStream.write(buffer);
        Log.i(TAG, "Write");
    }

    @Override
    public void flush() throws Exception {
        mOutputStream.flush();
    }

    @Override
    public int read(byte[] buffer, int byteOffset, int byteCount) throws Exception {
        return mInputStream.read(buffer, byteOffset, byteCount);
    }

    @Override
    public int readInt() throws Exception {
        return mInputStream.readInt();
    }

    @Override
    public short readShort() throws Exception {
        return mInputStream.readShort();
    }

    @Override
    public int read() throws Exception {
        return mInputStream.read();
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        mHandler.removeCallbacks(mSppCallback);
    }
    // --------------------------------- ConnectionTask --------------------------------------- //
    private class ConnectionTask extends AsyncTask<Object, Integer, Boolean> {
        @Override
        protected Boolean doInBackground(Object... arg) {
            final BluetoothDevice device = (BluetoothDevice) arg[0];
            if (device != null) {
                try {
                    /* let the data disconnect intent goes first */
                    Thread.sleep(500);
                    Log.d(TAG, "ConnectionTask" + device);
                    reConnectTime = 0;
                    if (isCancelled()) {
                        Log.i(TAG, "task cancelled");
                        return false;
                    } else {
                        return true;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            return false;
        }

        @Override
        protected void onPostExecute(Boolean result) {
            mAutoConnecting = false;
            mConnecting = false;
            mDeviceConnected = mBluetoothDevice;
            Log.i(TAG, "onPostExecute result:" + result);
            if (result) {
                connectSppSuccess();
            } else {
                Log.i(TAG, "onPostExecute");
                connectSppFail();
                if (mConnectListener != null) {
                    mConnectListener.onConnectFail();
                }
            }
        }
    }

    @Override
    public void release() {
        Log.i(TAG, "spp release");
        unPairDevice(mDeviceConnected);
        super.release();
    }

    private void unPairDevice(BluetoothDevice device) {
//        if (device == null || mIsStress) {
//            return;
//        }
//        try {
//            Method m = device.getClass().getMethod("removeBond");
//            m.invoke(device);
//        } catch (Exception e) {
//            Log.e(TAG, "unPairDevice:" + e);
//        }
    }
}
