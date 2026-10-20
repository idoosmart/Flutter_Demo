package com.idosmart.native_channel.actions.ibluz.device.bluzdevice;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothProfile;
import android.content.Context;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;


import com.idosmart.native_channel.actions.ibluz.device.DataBuffer;
import com.idosmart.native_channel.actions.ibluz.device.IBluzGetMTUListener;
import com.idosmart.native_channel.actions.ibluz.device.scan.ScanState;
import com.idosmart.native_channel.actions.ibluz.device.scan.SimpleScanCallback;
import com.idosmart.native_channel.actions.ibluz.factory.BluzDeviceFactory;
import com.idosmart.native_channel.actions.ibluz.util.Utils;

import java.lang.reflect.Method;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;

public class BluzDeviceEdrNew extends BluzDeviceBase{
    private String TAG = "BluzDeviceEdrNew";

    private int mGattReConnectTime = 0;

    private static final int MSG_CONNECTED = 1;
    private static final int MSG_DISCONNECTED = 2;
    private static final int MSG_FOUND = 3;
    private static final int MSG_SHOW_MESSAGE = 4;

    private static final int CONNECT_TIMEOUT = 10000;
    private static final int SCAN_TIMEOUT = 10000;

    private static UUID CLIENT_CHARACTERISTIC_CONFIGURATION = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb");
    private static UUID SERVICE = UUID.fromString("e49a25f8-f69a-11e8-8eb2-f2801f1b9fd1");
    private static UUID CHARACTERISTIC_WRITE_FIFO = UUID.fromString("e49a25e0-f69a-11e8-8eb2-f2801f1b9fd1");
    private static UUID CHARACTERISTIC_READ_FIFO = UUID.fromString("e49a28e1-f69a-11e8-8eb2-f2801f1b9fd1");

    private BluetoothGatt mBluetoothGatt;
    private BluetoothGattCharacteristic mCharacteristicReadFifo;
    private BluetoothGattCharacteristic mCharacteristicWriteFifo;

    private DataBuffer.WriteDataBuffer mWriteBuffer = null;
    private DataBuffer.ReadDataBuffer mReadBuffer = null;

    private BluetoothDevice mDeviceEdr = null;
    private Timer mTimer;

    private int mReTryTime = 0;

    private boolean mIsConnectEdr = false;

    private volatile boolean mIsSpeed = false;

    private volatile boolean mIsClose = false;

    public BluzDeviceEdrNew(Context context) {
        this(context, false, false);
    }

    public BluzDeviceEdrNew(Context context, boolean a2dp, boolean removeBound) {
        super(context, a2dp, removeBound);
        Log.i(TAG, "Create");
        mReTryTime = 0;
        final BluetoothManager bluetoothManager = (BluetoothManager) mContext.getSystemService(Context.BLUETOOTH_SERVICE);
        mBluetoothAdapter = bluetoothManager.getAdapter();

        mReadBuffer = new DataBuffer.ReadDataBuffer();
        mWriteBuffer = new DataBuffer.WriteDataBuffer(new DataBuffer.WriteCallback() {
            @Override
            public void onStart() {
                Log.i(TAG, "writeCharacteristic 1");
                writeCharacteristic();
            }
        });
        mIsConnectEdr = false;
        mIsSpeed = false;
    }

    // 为speed开口
    public void setSpeedMode(boolean isSpeed) {
        mIsSpeed = isSpeed;
    }

    // ----------------------------------- Notify ---------------------------------------- //
    @Override
    @SuppressLint("MissingPermission")
    public void closeNotify() {
        if (mBluetoothGatt != null) {
            BluetoothGatt gatt = mBluetoothGatt;
            if (mCharacteristicReadFifo != null) {
                Log.d(TAG, "read");
                mIsClose = false;
                BluetoothGattDescriptor descriptor = mCharacteristicReadFifo.getDescriptor(CLIENT_CHARACTERISTIC_CONFIGURATION);
                descriptor.setValue(BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE);
                gatt.writeDescriptor(descriptor);
                gatt.setCharacteristicNotification(mCharacteristicReadFifo, false);
            }
            if (mCharacteristicWriteFifo != null) {
                Log.d(TAG, "write");
                gatt.setCharacteristicNotification(mCharacteristicWriteFifo, false);
            }
        }
    }
    // ----------------------------------- connectService -------------------------------------- //


    // ----------------------------------- connectBle -------------------------------------- //
    @SuppressLint("MissingPermission")
    private void connectEdr() {
        Log.v(TAG, "connectEdr");
        mIsClose = true;
        updateConnectionState(BluzDeviceFactory.ConnectionState.SPP_CONNECTING);
        if (mTimer != null) {
            mTimer.cancel();
        }
//        mHandler.removeCallbacks(mScanCallback);
//        mHandler.postDelayed(mConnectCallback, CONNECT_TIMEOUT);
        String buildBound = Build.BRAND;
        mGattReConnectTime = 0;
        mBluetoothGatt = mDeviceEdr.connectGatt(mContext, false, mGattCallback);
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//            mBluetoothGatt = mDeviceEdr.connectGatt(mContext, false, mGattCallback, BluetoothDevice.TRANSPORT_BREDR);
//        }

    }

    @Override
    public void connectEdr(BluetoothGatt gatt) {
        this.mBluetoothGatt = gatt;
        this.mDeviceEdr = gatt.getDevice();
        connectEdr();
    }

    private BluetoothGattCallback mGattCallback = new BluetoothGattCallback() {
        @Override
        public void onPhyUpdate(BluetoothGatt gatt, int txPhy, int rxPhy, int status) {
            super.onPhyUpdate(gatt, txPhy, rxPhy, status);
        }

        @Override
        public void onPhyRead(BluetoothGatt gatt, int txPhy, int rxPhy, int status) {
            super.onPhyRead(gatt, txPhy, rxPhy, status);
        }

        @SuppressLint("MissingPermission")
        @Override
        public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
            Log.d(TAG, "onConnectionStateChange() called with: gatt = [" + gatt + "], status = [" + status + "], newState = [" + newState + "]");
            BluetoothDevice device = gatt.getDevice();
            if (newState == BluetoothProfile.STATE_CONNECTED) {
                if (mConnectListener != null) { // TODO connectlistener 为空，查一下原因
                    mReTryTime = 0;
                    if (gatt != null) {
                        mReTryTime = 0;
                        mConnectListener.onEdrConnectSuccess(gatt);
                    } else {
                        Log.i(TAG, "onConnectionStateChange gatt == null");
                        if (mIsStress) {
                            mBluetoothGatt.discoverServices();
                        }
                    }
                } else {
                    Log.i(TAG, "mConnectListener == null");
                    if (mIsStress) {
                        mBluetoothGatt.discoverServices();
                    }
                }
            } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
                Log.i(TAG, "onConnectionStateChange mIsStress:" + mIsStress);
                // 未连接成功
                if (mIsStress) {
                    Log.i(TAG, "re connect time:" + mReTryTime);
//
                    Timer timer = new Timer();
                    timer.schedule(new TimerTask() {
                        @Override
                        public void run() {
                            Log.w(TAG, "gatt null or device mismatch");
                            if (mReTryTime == 10) {
                                mReTryTime = 0;
                                closeNotify();
                                disconnect();
                                return ;
                            }

                            if (mBluetoothGatt != null) {
                                mBluetoothGatt.close();
                            }
                            if (gatt != null) {
                                gatt.close();
                            }
                            mReTryTime ++ ;
                            mBluetoothGatt = mDeviceEdr.connectGatt(mContext, false, mGattCallback);


                        }
                    }, 1000);
                } else {
                    Log.i(TAG, "Disconnected from GATT server.");
                    if (mConnectListener != null) {
                        mConnectListener.onConnectFail();
                    }
                }
            }
        }

        @Override
        public void onServicesDiscovered(BluetoothGatt gatt, int status) {
            Log.i(TAG, "onServicesDiscovered status:" + status);
            if (status == BluetoothGatt.GATT_SUCCESS) {
                findServiceAndCharacteristic(gatt);
            } else {
                Log.e(TAG, "onServicesDiscovered received: " + status);
                mServiceConnectListener.onServiceConnectFail();
            }
        }

        @Override
        public void onCharacteristicRead(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {
            if (mListener == null) {
                super.onCharacteristicRead(gatt, characteristic, status);
            } else {
                if (status == BluetoothGatt.GATT_SUCCESS) {
                    readCharacteristicSuccess(characteristic);
                }
            }
        }

        private void readCharacteristicSuccess(BluetoothGattCharacteristic characteristic) {
            if (TextUtils.equals(characteristic.getUuid().toString(), mCharacteristicReadFifo.getUuid().toString())) {
                android.util.Log.i(TAG, "readCharacteristicSuccess");
                byte[] value = characteristic.getValue();
                if (mListener != null)
                    mListener.onDataRead(value);
            }
        }

        @Override
        public void onCharacteristicWrite(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {
            Log.i(TAG, "onCharacteristicWrite: characteristic = [" + characteristic.getUuid()+"], status = ["  + status);
            if (status == BluetoothGatt.GATT_SUCCESS || status == BluetoothGatt.GATT_INVALID_ATTRIBUTE_LENGTH) {
                Log.i(TAG, "write success");
                if (mWriteListener != null && characteristic != null) {
                    mWriteListener.onWriteSuccess(characteristic.getValue().length);
                }
                writeCharacteristicSuccess(characteristic);
            } else {
                Log.w(TAG, "onCharacteristicWrite received: " + status);
            }
        }

        private void writeCharacteristicSuccess(BluetoothGattCharacteristic characteristic) {
            if (TextUtils.equals(characteristic.getUuid().toString(), mCharacteristicWriteFifo.getUuid().toString())) {
                if (mListener == null) {
                    if (mWriteBuffer.isEnd()) {
                        /* current item finish write next */
                        mWriteBuffer.next();
                    } else {
                        Log.i(TAG, "writeCharacteristic 2");
                        writeCharacteristic();
                    }
                } else {
                    if (characteristic.getWriteType() != BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE) {
                        mListener.onDataWrite(characteristic.getValue());
                    }
                }
            }
        }

        @Override
        public void onCharacteristicChanged(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic) {
            Log.i(TAG, "onCharacteristicChanged: characteristic = [" + characteristic.getUuid()+"]");
            readIndicator(characteristic);
        }

        public void readIndicator(BluetoothGattCharacteristic characteristic) {
            if (TextUtils.equals(characteristic.getUuid().toString(), mCharacteristicReadFifo.getUuid().toString())) {
                Log.i(TAG, "readIndicator");
                byte[] buffer = characteristic.getValue();
                if (mListener == null) {
                    mReadBuffer.add(buffer.length);
                    mReadBuffer.write(buffer);
                } else {
                    mListener.onDataRead(buffer);
                }
            }
        }

        @Override
        public void onDescriptorRead(BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status) {
            super.onDescriptorRead(gatt, descriptor, status);
        }

        @SuppressLint("MissingPermission")
        @Override
        public void onDescriptorWrite(BluetoothGatt gatt, BluetoothGattDescriptor descriptor, int status) {
            if (!mIsClose) {
                return;
            }
            Log.d(TAG, "onDescriptorWrite() called with: gatt = [" + gatt + "], descriptor = [" + descriptor + "], status = [" + status + "]");
            if (status == BluetoothGatt.GATT_SUCCESS) {
                //	knockDoor();
                if (Build.VERSION.SDK_INT >= 21) {
                    //for device don't have requestMtu method but has MTU larger than 20 like MX5

                    Log.v(TAG, "android.os.Build.MANUFACTURER: " + Build.MANUFACTURER + " " + Build.MODEL);
                    if ("Meizu".equals(Build.MANUFACTURER)) {
                        // 魅族手机,其蓝牙模组不遵循MTU协议，手机与设备无法协商MTU长度，可能导致发包长度超出设备处理能力�?
                        // 因此MTU设置�?0byte的有效负载，以兼容更多的设备�?
                        mWriteBuffer.setWriteMaxLength(20);
                    } else if ("Xiaomi".equals(Build.MANUFACTURER) && "Mi-4c".equals(Build.MODEL)) {
                        //小米4C设置大MTU，会导致包头被丢掉几十个byte的问�?
                        mBluetoothGatt.requestMtu(20);
                    } else if ("QiKU".equals(Build.MANUFACTURER) && "8692-M02".equals(Build.MODEL)) {
                        // 该手机蓝牙拆包传输会出错
                        mBluetoothGatt.requestMtu(20);
                    } else {
                        mBluetoothGatt.requestConnectionPriority(BluetoothGatt.CONNECTION_PRIORITY_HIGH);
                        mBluetoothGatt.requestMtu(512);
                    }
                    // delay to prevent 133 problem
                    // delay here but not in the mtu callback because
                    // some device don't have requestMtu Method like Meizu Mx5
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                mDeviceConnected = mBluetoothDevice;
                updateConnectionState(BluzDeviceFactory.ConnectionState.SPP_CONNECTED);
                Log.i(TAG, "onDescriptorWrite");
                mServiceConnectListener.onServiceConnected();
            } else {
                Log.w(TAG, "onDescriptorWrite received:" + status);
                mServiceConnectListener.onServiceConnectFail();
            }
        }

        @Override
        public void onReliableWriteCompleted(BluetoothGatt gatt, int status) {
            super.onReliableWriteCompleted(gatt, status);
        }

        @Override
        public void onReadRemoteRssi(BluetoothGatt gatt, int rssi, int status) {
            super.onReadRemoteRssi(gatt, rssi, status);
        }

        @Override
        public void onMtuChanged(BluetoothGatt gatt, int mtu, int status) {
            Log.d(TAG, "onMtuChanged() called with: gatt = [" + gatt + "], mtu = [" + mtu + "], status = [" + status + "]");
            //20 to ensure that shorter command can succeed when mtu change failed
            int finalMtu = 20;
            if (status == BluetoothGatt.GATT_SUCCESS) {
                finalMtu = mtu-5;
                if (mListener != null) {
                    mListener.onWriteMtuChanged(finalMtu);
                }
            }
            mWriteMTU = finalMtu;
            Log.v(TAG, "onMtuChanged: " + finalMtu);
            if (mIsRunning) {
                Log.e(TAG, "onMtuChanged is running!");
                return ;
            }
            mWriteBuffer.setWriteMaxLength(finalMtu);
            Log.i(TAG, "null mMtuListener:" + mtu);
            if (mMtuListener != null) {
                Log.i(TAG, "mMtuListener:" + mtu);
                mMtuListener.getMtu(mtu);
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                //mBluetoothGatt.setPreferredPhy(BluetoothDevice.PHY_LE_2M, BluetoothDevice.PHY_LE_2M, BluetoothDevice.PHY_OPTION_NO_PREFERRED);
            }
        }

        @Override
        public void onServiceChanged(@NonNull BluetoothGatt gatt) {
            super.onServiceChanged(gatt);
        }
    };

    public void setMtu(int mtu) {
        mWriteBuffer.setWriteMaxLength(mtu);
    }

    // ----------------------------------- characteristic ----------------------------------- //
    @SuppressLint("MissingPermission")
    private void writeCharacteristic() {
        Log.v(TAG, "writeCharacteristic()");
        if (mBluetoothGatt != null && mCharacteristicWriteFifo != null) {
            byte[] buffer = mWriteBuffer.getBuffer(true);
            Utils.printHexBuffer(TAG, buffer);
            Log.e(TAG, "writeCharacteristic buffer.length:" + buffer.length);
            mCharacteristicWriteFifo.setValue(buffer);
            mBluetoothGatt.writeCharacteristic(mCharacteristicWriteFifo);
        } else {
            Log.v(TAG, "gatt == null");
        }
    }

    @Override
    public void connectServiceAndCharacteristic(HashMap<String, UUID> uuids, BluetoothGatt gatt, OnServiceConnectListener serviceConnectListener) {
        this.mServiceConnectListener = serviceConnectListener;
        if (gatt.getServices().isEmpty()) {
            mServiceConnectListener.onServiceConnectFail();
            return;
        }
        mIsConnectEdr = true;
        mBluetoothGatt = gatt;
        setUUID(uuids);
        findServiceAndCharacteristic(gatt);
    }

    @SuppressLint("MissingPermission")
    private void findServiceAndCharacteristic(BluetoothGatt gatt) {
        List<BluetoothGattService> services = gatt.getServices();
        for (BluetoothGattService service : services) {
            Log.i(TAG, "service uuid:" + service.getUuid().toString());
            List<BluetoothGattCharacteristic> characteristics = service.getCharacteristics();

            BluetoothGattCharacteristic readFifo = null;
            BluetoothGattCharacteristic writeFifo = null;

            if (service.getUuid().equals(SERVICE)) {
                Log.e(TAG, "service.getUuid():" + service.getUuid());
                Log.e(TAG, "service" + SERVICE);
                for (BluetoothGattCharacteristic characteristic : characteristics) {
                    Log.i(TAG, "read characteristic uuid:" + characteristic.getUuid().toString());
                    UUID uuid = characteristic.getUuid();
                    if (uuid.equals(CHARACTERISTIC_READ_FIFO)) {
                        mCharacteristicReadFifo = characteristic;
                        readFifo = characteristic;
                    } else if (uuid.equals(CHARACTERISTIC_WRITE_FIFO)) {
                        characteristic.setWriteType(BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE);
                        mCharacteristicWriteFifo = characteristic;
                        writeFifo = characteristic;

                    }
                }
            }
            if (readFifo != null && writeFifo != null) {
                Log.i(TAG, "write fifo type:" + mCharacteristicWriteFifo.getWriteType());
                Log.i(TAG, "read fifo type:" + mCharacteristicReadFifo.getWriteType());
                Log.i(TAG, "write fifi property:" + mCharacteristicWriteFifo.getProperties());
                Log.i(TAG, "read fifo property:" + mCharacteristicReadFifo.getProperties());

                enableCCC(readFifo, gatt);
                return;
            }
        }
        mServiceConnectListener.onServiceConnectFail();
    }

    @SuppressLint("MissingPermission")
    private void enableCCC(BluetoothGattCharacteristic characteristic, BluetoothGatt gatt) {
        Log.i(TAG, "enableCCC" );
        //setWriteType is necessary so that notification is enable
        characteristic.setWriteType(BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT);
        gatt.setCharacteristicNotification(characteristic, true);
        BluetoothGattDescriptor descriptor = characteristic.getDescriptor(CLIENT_CHARACTERISTIC_CONFIGURATION);
        descriptor.setValue(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE);
        Log.i(TAG, "enableCCC writeDescriptor");
        gatt.writeDescriptor(descriptor);

        //
        if (mIsConnectEdr) {
            Log.i(TAG, "sleep");
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            Log.i(TAG, "service connected");
            updateConnectionState(BluzDeviceFactory.ConnectionState.SPP_CONNECTED);
//            readIndicator(characteristic);
            mServiceConnectListener.onServiceConnected();
        }
    }

    public void readIndicator(BluetoothGattCharacteristic characteristic) {
        if (TextUtils.equals(characteristic.getUuid().toString(), mCharacteristicReadFifo.getUuid().toString())) {
            byte[] buffer = characteristic.getValue();
            mReadBuffer.add(buffer.length);
            mReadBuffer.write(buffer);
        }
    }

    // ----------------------------------- Override -------------------------------------- //
    @Override
    public void connect() {
        super.connect();
        if (mBluetoothDevice == null) {
            Log.e("ble", "ble == null");
            return;
        }
        mDeviceEdr = mBluetoothDevice;
        connectEdr();
    }

    @SuppressLint("MissingPermission")
    @Override
    public void disconnect() {
        Log.i(TAG, "disconnect!");
        BluetoothGatt gatt = mBluetoothGatt;
        if (gatt != null) {
            if (mConnectionListener != null && mDeviceConnected!=null ) {
                Log.i(TAG, "handleMessage: mConnectionListener");
                mConnectionListener.onDisconnected(mDeviceConnected);
                mDeviceConnected = null;
                updateConnectionState(BluzDeviceFactory.ConnectionState.SPP_DISCONNECTED);
            }
            refreshDeviceCache(mBluetoothGatt);
            closeNotify();
            gatt.disconnect();
            gatt.close();
            gatt = null;
            mBluetoothGatt = null;
        }
        if (mDeviceA2dp != null) {
            mDeviceA2dp.disconnect(mDeviceConnected == null ? mDeviceA2dp.getConnectedDevice() : mDeviceConnected);
        }
    }

    private boolean refreshDeviceCache(BluetoothGatt gatt) {
        Log.i(TAG, "清理gatt缓存");
        if (null != gatt) {
            try {
                Method localMethod = gatt.getClass().getMethod("refresh", new Class[0]);
                if (localMethod != null) {
                    boolean bool = ((Boolean) localMethod.invoke(gatt, new Object[0]))
                            .booleanValue();
                    return bool;
                }
            } catch (Exception localException) {
                localException.printStackTrace();
            }
        }
        return false;
    }

    @Override
    public void write(byte[] buffer) throws Exception {
        Log.i(TAG, "ble write");
        if (mListener == null) {
            boolean success = mWriteBuffer.add(buffer);
            if (!success) {
                Log.i(TAG, "too much command, dump:" + buffer.toString());
            }
        } else {
            if (mIsSpeed) {
                writeCharacteristic(buffer);
            }
            if (mCharacteristicWriteFifo.getWriteType() == BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE) {
                mListener.onDataWrite(buffer);
            }
        }
    }

    @SuppressLint("MissingPermission")
    private void writeCharacteristic(byte[] buffer) {
        if (mBluetoothGatt != null) {
            //	byte[] buffer = mWriteBuffer.getBuffer();
            Utils.printHexBuffer(TAG, buffer);

            //	Log.v(TAG, "writeCharacteristic: " + buffer);
            mCharacteristicWriteFifo.setWriteType(BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE);
            mCharacteristicWriteFifo.setValue(buffer);
            mBluetoothGatt.writeCharacteristic(mCharacteristicWriteFifo);
        }
    }

    @Override
    public void flush() throws Exception {
    }

    @Override
    public int read(byte[] buffer, int byteOffset, int byteCount) throws Exception {
        Log.e(TAG, "buffer len:" + buffer.length + ";byteoffset:" + byteOffset + ";byteCount:" + byteCount);
        int res = mReadBuffer.read(buffer, byteOffset, byteCount);
        Log.e(TAG, "read res = " + res);
        return res;
    }

    @Override
    public int readInt() throws Exception {
        byte[] buffer = new byte[4];
        read(buffer, 0, 4);
        ByteBuffer wrapped = ByteBuffer.wrap(buffer);
        return wrapped.getInt();
    }

    @Override
    public short readShort() throws Exception {
        byte[] buffer = new byte[2];
        read(buffer, 0, 2);
        ByteBuffer wrapped = ByteBuffer.wrap(buffer);
        return wrapped.getShort();
    }

    @Override
    public int read() throws Exception {
        Log.e(TAG, "read");
        byte[] buffer = new byte[1];
        read(buffer, 0, 1);
        int res = buffer[0] & 0xff;
        Log.e(TAG, "read res:" + res);
        return res;
    }

    // 如果是ble
    public void setUUID(Map<String, UUID> uuids) {
        Log.i(TAG, "setUUID");
//        mCharacteristicReadFifo = null;
//        mCharacteristicWriteFifo = null;
        int mapSize = uuids.size();
        Iterator it = uuids.entrySet().iterator();
        for (int i=0; i < mapSize; i++){
            Map.Entry<String,UUID> entry = (Map.Entry<String,UUID>) it.next();
            String key = entry.getKey();
            Log.i(TAG, "setUUID key:" + key);
            UUID value = entry.getValue();
            if (key.equals(BluzDeviceFactory.KeyUUIDS.keyConfigurationUUID)){
                CLIENT_CHARACTERISTIC_CONFIGURATION = value;
                Log.d(TAG,"setUUID keyConfigurationUUID: " + value.toString());
            }
            else if (key.equals(BluzDeviceFactory.KeyUUIDS.keyServiceUUID)){
                SERVICE = value;
                Log.d(TAG,"setUUID keyServiceUUID: " + value.toString());
            }
            else if (key.equals(BluzDeviceFactory.KeyUUIDS.keyReadCharacteristicUUID)){
                CHARACTERISTIC_READ_FIFO = value;
                Log.d(TAG,"setUUID keyReadCharacteristicUUID: " + value.toString());
            }
            else if (key.equals(BluzDeviceFactory.KeyUUIDS.keyWriteCharacteristicUUID)){
                CHARACTERISTIC_WRITE_FIFO = value;
                Log.d(TAG,"setUUID keyWriteCharacteristicUUID: " + value.toString());
            }
        }
    }

    public void onWrite(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {
        Log.i(TAG, "onCharacteristicWrite: characteristic = [" + characteristic.getUuid() + "], status = [" + status);
        if (status == BluetoothGatt.GATT_SUCCESS || status == BluetoothGatt.GATT_INVALID_ATTRIBUTE_LENGTH) {
            Log.i(TAG, "write success");
            writeCharacteristicSuccess(characteristic);
        } else {
            Log.w(TAG, "onCharacteristicWrite received: " + status);
        }
    }

    private void writeCharacteristicSuccess(BluetoothGattCharacteristic characteristic) {

        if (TextUtils.equals(characteristic.getUuid().toString(), mCharacteristicWriteFifo.getUuid().toString())) {
            if (mWriteBuffer.isEnd()) {
                /* current item finish write next */
                mWriteBuffer.next();
            } else {
                Log.i(TAG, "writeCharacteristic 2");
                writeCharacteristic();
            }
        }
    }

    private SimpleScanCallback simpleScanCallback = new SimpleScanCallback() {
        @Override
        public void onScan(BluetoothDevice device, int rssi, byte[] scanRecord) {
            if (mDiscoveryListener == null) {
                Log.i(TAG, "mDiscoveryListener == null");
                return ;
            }
            mDiscoveryListener.onFound(device, BluzDeviceFactory.DiscoveryType.DISCOVERY_NORMAL);
        }

        @Override
        public void onScanFailed(ScanState scanState) {

        }
    };

    class MyTimerTask extends TimerTask {
        @Override
        public void run() {
            Log.i(TAG, "mScanCallback timeout");
            cancelDiscovery();
        }
    }

    // speed 部分需要功能
    private OnBleListener mListener;
    private static final int DEFAULT_MTU = 512;
    private int mWriteMTU = DEFAULT_MTU;

    public void setSpeedListener(OnBleListener listener) {
        mListener = listener;
        mListener.onWriteMtuChanged(mWriteMTU);
    }

    public interface OnBleListener {
        void onWriteMtuChanged(int mtu);
        void onDataWrite(byte[] data);
        void onDataRead(byte[] data);
    }

    public IBluzGetMTUListener mMtuListener;
    public void setMtuListener(IBluzGetMTUListener listener) {
        this.mMtuListener = listener;
    }
}
