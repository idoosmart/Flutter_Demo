package com.example.flutter_bluetooth.ble.device;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCharacteristic;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;

import com.example.flutter_bluetooth.ble.config.BLEGattAttributes;
import com.example.flutter_bluetooth.ble.callback.DeviceGattCallBack;
import com.example.flutter_bluetooth.utils.ByteDataConvertUtil;
import com.example.flutter_bluetooth.utils.Constants;
import com.example.flutter_bluetooth.logger.Logger;

import java.lang.reflect.Field;
import java.util.LinkedList;

/**
 * Created by asus on 2018/1/17.
 */

public abstract class BytesDataConnect extends BaseConnect {

    private static final int WHAT_SEND_NO_ANSWER_TIMEOUT = 1;

    /**
     * 发送过去之后，无响应的超时时间
     */
    private static final long TIME_SEND_TIMEOUT = 3000;

    private static final int MAX_CMD_QUEUE_SIZE = 10;
    /**
     * 待发送数据命令 队列
     */
    private final LinkedList<byte[]> mCmdDataQueue = new LinkedList<>();

    /**
     * 是否正在发送数据
     */
    private boolean mIsSendingCmdData = false;

    /**
     * 是否正在重发数据
     */
    private boolean mIsReSendData = false;
    /**
     * 连续写入失败的次数
     */
    private int mWriteDataFailedCount = 0;

    private BluetoothGattCharacteristic mWriteNormalGattCharacteristic;
    private BluetoothGattCharacteristic mWriteHealthGattCharacteristic;

    private final Handler mHandler = new Handler(Looper.getMainLooper()) {
        @Override
        public void handleMessage(Message msg) {
            if (msg.what == WHAT_SEND_NO_ANSWER_TIMEOUT && mIsSendingCmdData) {
                mIsSendingCmdData = false;
                if (mCmdDataQueue.size() > MAX_CMD_QUEUE_SIZE) {
                    Logger.e("[BytesDataConnect] last send out time, mCmdDataQueue.size() > 10, clear and disconnect");
                    clearQueueAndDisconnect();
                } else {
                    Logger.e("[BytesDataConnect] no respond on last cmd, send next ...");
                    sendNextCmdData();
                }
            }
        }
    };

    BytesDataConnect(String deviceAddress) {
        super(deviceAddress);
    }

    private void clearQueueAndDisconnect() {
        Logger.e("[BytesDataConnect] clearQueueAndDisconnect");
        mCmdDataQueue.clear();
        disConnect();
    }

//    private void handleWriteFailedStatus(){
//        mIsSendingCmdData = false;
//        if (mCmdDataQueue.size() > MAX_CMD_QUEUE_SIZE){
//            Logger.e("[BytesDataConnect] handleWriteFailedStatus, mCmdDataQueue.size() > 10, clear and disconnect");
//            clearQueueAndDisconnect();
//        }else {
//            Logger.e("[BytesDataConnect] handleWriteFailedStatus, send next ...");
//            sendNextCmdData();
//        }
//    }

    private void handleFileTranDataFailedStatus(byte[] failedData) {
        if (!isCanSendData()) {
            mIsReSendData = false;
            mWriteDataFailedCount = 0;
            Logger.e("[BytesDataConnect] handleWriteFailedStatus(), isCanSendData = false. send failed");
            return;
        }

        mWriteDataFailedCount++;
        if (mWriteDataFailedCount > 10) {
            Logger.e("[BytesDataConnect] handleWriteFailedStatus, mSendFailedCount > 10, clear and disconnect");
            clearQueueAndDisconnect();
            mIsReSendData = false;
            mWriteDataFailedCount = 0;
            return;
        }

        //有的时候写入过快，会导致失败，所以这里重发
        //重发时必须要保证顺序不能变（像文件传输相关命令，不能错乱，错乱了就会导致传输失败）
        //只重发“文件传输相关的命令” + Alexa语音命令
        if (isFileTranCmd(failedData) || isSendAlexaVoiceCmd(failedData)) {
            mIsReSendData = true;
            Logger.e("[BytesDataConnect] isFileTranCmd  mIsReSendData:" + mIsReSendData);
            resendData(failedData);
        } else {
            mIsSendingCmdData = false;
            sendNextCmdData();
        }
    }

    private synchronized void sendNextCmdData() {
        if (mIsSendingCmdData) {
            Logger.e("[BytesDataConnect] sendNextCmdData is ing");
            return;
        }

        if (mIsReSendData) {
            Logger.e("[BytesDataConnect] retrySendData is ing");
            return;
        }

        if (mCmdDataQueue.size() == 0) {
            return;
        }
        mIsSendingCmdData = true;

        final byte[] data = mCmdDataQueue.poll();
        if (data == null) {
            Logger.e("[BytesDataConnect] sendNextCmdData data is null");
            mIsSendingCmdData = false;
            sendNextCmdData();
            return;
        }

//        Logger.p("[BytesDataConnect] send => " + ByteDataConvertUtil.bytesToHexString(data));
        if (!isCanSendData()) {
            mIsSendingCmdData = false;
            Logger.e("[BytesDataConnect] send(), isCanSendData = false. send failed");
            return;
        }

        sendData(data);

//        boolean result = writeBytes(data);
//        if (!result){
//            handleWriteFailedStatus(data);
//            return;
//        }
//        //只要有一次写入成功，就清零
//        mWriteDataFailedCount = 0;
//
//        if (isNoNeedWaitResponseCmd(data)){
//            mIsSendingCmdData = false;
//            sendNextCmdData();
//        }else {
//            mIsSendingCmdData = true;
//            mHandler.sendEmptyMessageDelayed(WHAT_SEND_NO_ANSWER_TIMEOUT, TIME_SEND_TIMEOUT);
//        }

    }

    private void resendData(final byte[] data) {
        //post到队列里，延时一会
        mHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                mIsReSendData = true;
                Logger.e("[BytesDataConnect] retry send => " + ByteDataConvertUtil.bytesToHexString(data));
                sendData(data);
            }
        }, 300);

    }

    private void sendData(byte[] data) {
        boolean result = writeBytes(data);
        if (!result) {
//            if (isFileTranCmd(data)) {
//                handleFileTranDataFailedStatus(data);
//            }else {
//                mIsSendingCmdData = false;
//                sendNextCmdData();
//            }

            handleFileTranDataFailedStatus(data);
            return;
        }
        //只要有一次写入成功，就清零
        mWriteDataFailedCount = 0;
        //只要重发(写入)没有成功，就不会走到这里来
        mIsReSendData = false;
        if (isNoNeedWaitResponseCmd(data)) {
            mIsSendingCmdData = false;
            sendNextCmdData();
        } else {
            mHandler.sendEmptyMessageDelayed(WHAT_SEND_NO_ANSWER_TIMEOUT, TIME_SEND_TIMEOUT);
        }
    }

    private BluetoothGatt getRealGatt() {
        return getGatt();
    }

    @SuppressLint("MissingPermission")
    private boolean writeBytes(byte[] data) {
        final BluetoothGattCharacteristic characteristic = getGattCharacteristic(getRealGatt(), data);
        if (characteristic != null && (BluetoothGattCharacteristic.PROPERTY_WRITE & characteristic.getProperties()) > 0) {
            characteristic.setValue(data);

            if (isNoNeedWaitResponseCmd(data)) {
                characteristic.setWriteType(BluetoothGattCharacteristic.WRITE_TYPE_NO_RESPONSE);
            } else {
                characteristic.setWriteType(BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT);
            }
//            if (BluetoothGattSettingListener.getBluetoothGattSettingListener() != null){
//                BluetoothGattSettingListener.getBluetoothGattSettingListener().addParaToCharacteristic(characteristic);
//            }
        } else {
            Logger.e("[BytesDataConnect] send(), characteristic error!");
            return false;
        }

        int properties = characteristic.getProperties();

        if ((properties & 0xC) == 0) {
            Logger.e("[BytesDataConnect] send(), characteristic.properties error!");
            return false;
        }

        if (getRealGatt() == null) {//防止蓝牙断开后，被清除了
            Logger.e("[BytesDataConnect] send(), getRealGatt == null");
            return false;
        }
        boolean result = false;
        try {
            result = getRealGatt().writeCharacteristic(characteristic);//之前的写法，当读写操作频繁时，容易报 [BytesDataConnect] send(), writeCharacteristic() error!
            //result = writeCharacteristic(characteristic);
            if (!result) {
                Logger.e("[BytesDataConnect] send(), writeCharacteristic() error!");
            }
        } catch (Exception e) {
            Logger.e("[BytesDataConnect] send(), writeCharacteristic() Exception!");
        }

        return result;
    }

    private static long HONEY_CMD_TIMEOUT = 3000;

    @SuppressLint("MissingPermission")
    protected boolean writeCharacteristic(BluetoothGattCharacteristic characteristic) {
        if (getRealGatt() == null) {
            Logger.e("[BytesDataConnect] getRealGatt() == null!");
            return false;
        }
        long enterTime = System.currentTimeMillis();
        while ((System.currentTimeMillis() - enterTime) < HONEY_CMD_TIMEOUT) {
            if (isDeviceBusy()) {
                try {
                    Thread.sleep(30);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                    Logger.e("[BytesDataConnect] mDeviceBusy == true，e.printStackTrace() :" + e.toString());
                }
            } else {
                Logger.e("[BytesDataConnect] mDeviceBusy == false，break");
                break;
            }
        }
        if (getRealGatt() == null) {//防止在等待时，蓝牙断链 gatt 被置空导致崩溃
            Logger.e("[BytesDataConnect] getRealGatt() == null!");
            return false;
        }
        return getRealGatt().writeCharacteristic(characteristic);
    }

    private boolean isDeviceBusy() {
        boolean state = false;
        try {
            state = (boolean) readField(getRealGatt(), "mDeviceBusy");
        } catch (IllegalAccessException | NoSuchFieldException e) {
            e.printStackTrace();
            Logger.e("[BytesDataConnect] isDeviceBusy()，e.printStackTrace() :" + e.toString());
        }
        return state;
    }

    //反射读取 源码中的 mDeviceBusy
    public Object readField(Object object, String name) throws IllegalAccessException, NoSuchFieldException {
        Field field = object.getClass().getDeclaredField(name);
        field.setAccessible(true);
        return field.get(object);
    }

    private BluetoothGattCharacteristic getGattCharacteristic(BluetoothGatt gatt, byte[] data) {
        if (isHealthCmd(data)) {
            if (mWriteHealthGattCharacteristic == null) {
                mWriteHealthGattCharacteristic = BLEGattAttributes.getHealthWriteCharacteristic(gatt);
            }
            return mWriteHealthGattCharacteristic;
        } else {
            if (mWriteNormalGattCharacteristic == null) {
                mWriteNormalGattCharacteristic = BLEGattAttributes.getNormalWriteCharacteristic(gatt);
            }

            return mWriteNormalGattCharacteristic;
        }
    }

    private boolean isHealthCmd(byte[] cmd) {
        return cmd[0] == 0x08 || cmd[0] == 0x09;// 健康数据命令 新增0x09
    }

    private boolean isNoNeedWaitResponseCmd(byte[] cmd) {
        //针对Agps文件的协议、Alexa语音
        return (cmd[0] & 0xff) == 0xD1 || (cmd[0] & 0xff) == 0x13;
    }


    private BluetoothGattCharacteristic getGattCharacteristic(
            BluetoothGatt gatt, Constants.CommandType commandType) {
        if (isHealthCmd(commandType)) {
            if (mWriteHealthGattCharacteristic == null) {
                mWriteHealthGattCharacteristic = BLEGattAttributes.getHealthWriteCharacteristic(gatt);
            }
            return mWriteHealthGattCharacteristic;
        } else {
            if (mWriteNormalGattCharacteristic == null) {
                mWriteNormalGattCharacteristic = BLEGattAttributes.getNormalWriteCharacteristic(gatt);
            }
            return mWriteNormalGattCharacteristic;
        }
    }

    private boolean isNoNeedWaitResponseCmd(Constants.WriteType writeType) {
        return writeType == Constants.WriteType.NO_RESPONSE;
    }

    private boolean isHealthCmd(Constants.CommandType commandType) {
        return commandType == Constants.CommandType.HEALTH;
    }


    /**
     * 是否为 文件传输的命令
     *
     * @param cmd
     * @return
     */
    private boolean isFileTranCmd(byte[] cmd) {
        return (cmd[0] & 0xff) == 0xD1;
    }

    /**
     * 是否为 下发Alexa语音的命令、设备获取登录状态
     *
     * @param cmd
     * @return
     */
    private boolean isSendAlexaVoiceCmd(byte[] cmd) {
        return (cmd[0] & 0xff) == 0x13 || (cmd[0] & 0xff) == 0x11;
    }

    private void receiverDeviceData(byte[] values) {
//        Logger.p("[BytesDataConnect] receive <= " + ByteDataConvertUtil.bytesToHexString(values));
    }

    protected void addCmdData(byte[] cmd, boolean isForce) {
        if (cmd == null || cmd.length == 0) {
            Logger.e("[BytesDataConnect] onAddCmd() ignore, data is null");
            return;
        }

//        Logger.p("[BytesDataConnect] addCmdData( " + ByteDataConvertUtil.bytesToHexString(cmd) + ")");


        if (isForce) {
            mCmdDataQueue.addFirst(cmd);
        } else {
            mCmdDataQueue.add(cmd);
        }

        Logger.p("[BytesDataConnect] addCmdData que size = " + mCmdDataQueue.size());

        sendNextCmdData();
    }

    private void handleCmdDataQueue() {
        //如果待发送cmd数量超过最大限值，则移除前面的，保留最新的5个
        if (mCmdDataQueue.size() > MAX_CMD_QUEUE_SIZE) {
            Logger.e("[BytesDataConnect] cmd queue is out of max size, handle it...");
            for (int i = 0; i < MAX_CMD_QUEUE_SIZE - 5; i++) {
                mCmdDataQueue.pollFirst();
            }
        }
    }

    @Override
    protected void connect(String mac) {
        super.connect(mac);
        reset();
    }

    @Override
    protected void connect() {
        super.connect();
        reset();
    }

    @Override
    protected void connect(long timeoutMills) {
        super.connect(timeoutMills);
        reset();
    }

    private void reset() {
        destroy();
    }

    private void destroy() {
        mCmdDataQueue.clear();
        mIsSendingCmdData = false;
        mIsReSendData = false;
        mWriteDataFailedCount = 0;
        mHandler.removeCallbacksAndMessages(null);
        mWriteHealthGattCharacteristic = null;
        mWriteNormalGattCharacteristic = null;
    }

    private void deviceResponseOnLastSend(byte[] values, int status) {
        if (status == BluetoothGatt.GATT_SUCCESS) {
            Logger.p("[BytesDataConnect] onDeviceResponseOnLastSend( " + ByteDataConvertUtil.bytesToHexString(values) + ")");
        } else {
            Logger.e("[BytesDataConnect] onDeviceResponseOnLastSend[failed]( " + ByteDataConvertUtil.bytesToHexString(values) + ")");
        }

        mIsSendingCmdData = false;
        mHandler.removeMessages(WHAT_SEND_NO_ANSWER_TIMEOUT);
//        handleCmdDataQueue();
        sendNextCmdData();
    }


    @Override
    public void callOnCharacteristicWrite(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status) {
        deviceResponseOnLastSend(characteristic.getValue(), status);
        DeviceGattCallBack.onCharacteristicWrite(gatt, characteristic, status);
    }

    @Override
    public void callOnCharacteristicChanged(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic) {
        receiverDeviceData(characteristic.getValue());
        DeviceGattCallBack.onCharacteristicChanged(gatt, characteristic);
    }

    @Override
    public void callOnConnectBreakByGATT(int status, int newState) {
        destroy();
    }

    @Override
    public void callOnConnectClosed() {
        destroy();
    }

    @Override
    public void callOnConnectTimeOut() {

    }
}