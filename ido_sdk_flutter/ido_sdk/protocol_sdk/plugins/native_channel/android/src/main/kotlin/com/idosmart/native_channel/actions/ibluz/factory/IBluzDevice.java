package com.idosmart.native_channel.actions.ibluz.factory;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCharacteristic;


import com.idosmart.native_channel.actions.ibluz.device.GetConnectedDeviceList;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

public interface IBluzDevice {
    /**
     * 设置设备是否正在运行数据传输
     */
    public void setIsRunning(boolean isRunning);

    /**
     * 获取设备使能信息
     *
     * @return true 表示已打开
     */
    public boolean isEnabled();

    /**
     * 打开蓝牙
     *
     * @return true 表示正在打开
     */
    public boolean enable();

    /**
     * 设置压测环境
     * @param isStress
     */
    public void setStressMode(boolean isStress);
    /**
     * 关闭蓝牙
     *
     * @return true 表示正在关闭
     */
    public boolean disable();

    /**
     * 开始扫描蓝牙设备
     */
    public void startDiscovery();

    /**
     * 停止扫描蓝牙设备
     */
    public void cancelDiscovery();

    /**
     * 连接失败后重连
     *
     * @param device
     *            蓝牙设备
     */
    public void retry(BluetoothDevice device);

    /**
     * 连接蓝牙设备，当前应用所需的Profile
     *
     * @param device
     *            蓝牙设备
     */
    public void connect(BluetoothDevice device);

    /**
     * 断开全部连接
     *
     * @param device
     *            蓝牙设备
     */
    public void disconnect(BluetoothDevice device);

    /**
     * 设置是否自动连接数据通道(默认是自动连接)
     *
     * @param enable
     *            是否使能
     */
    public void setAutoConnectDataChanel(boolean enable);

    /**
     * 获取当前已连接的设备，含音频和数据
     *
     * @return 蓝牙设备
     */
    public BluetoothDevice getConnectedDevice();

    /**
     * 获取当前已连接的音频设备
     *
     * @return 蓝牙设备
     */
    public BluetoothDevice getConnectedA2dpDevice();

    /**
     * 获取当前已配对设备
     *
     * @return 蓝牙设备集合
     */
    public Set<BluetoothDevice> getBoundedDevices();

    /**
     * 设置连接回调监听
     *
     * @param listener
     *            监听
     */
    public void setOnConnectionListener(OnConnectionListener listener);

    /**
     * 设置搜索设备回调监听
     *
     * @param listener
     *            监听
     */
    public void setOnDiscoveryListener(OnDiscoveryListener listener);

    /**
     * 设置写回调监听
     *
     * @param listener
     *            监听
     */
    public void setOnWriteListener(OnWriteListener listener);

    public void setOnConnectStateListener(OnConnectStateListener listener);

    public void setUUID(Map<String, UUID> uuids);

    public void setUUID(UUID uuid);

    public void setOnServiceConnectListener(OnServiceConnectListener listener);

    public void connectServiceAndCharacteristic(HashMap<String, UUID> uuids, BluetoothGatt gatt, OnServiceConnectListener serviceConnectListener);

    public void getConnectedList(GetConnectedDeviceList listener);

    public void setBleConnectListener(OnBleConnectListener listener);

    /**
     * 断开数据连接，释放资源
     */
    public void release();

    public static interface  OnBleConnectListener {
        void onConnect(boolean isConnect);
    }

    public static interface OnServiceConnectListener {
        void onServiceConnected();
        void onServiceConnectFail();
    }

    /** 搜索设备回调 */
    public static interface OnDiscoveryListener {
        /**
         * 连接状态改变
         *
         * @param device
         *            蓝牙设备
         * @param state
         *            连接状态，{@link BluzDeviceFactory.ConnectionState}
         */
        public void onConnectionStateChanged(BluetoothDevice device, int state);

        /**
         * 搜索开始
         */
        public void onDiscoveryStarted();

        /**
         * 搜索结束
         */
        public void onDiscoveryFinished();

        /**
         * 找到设备
         *
         * @param device
         *            蓝牙设备
         */
        public void onFound(BluetoothDevice device, int type);

        /**
         * 找到已绑定设备列表
         *
         * @param devices
         *            已绑定蓝牙设备列表
         */
        public void onFoundBoundedDevices(List<BluetoothDevice> devices);

        public void onFoundBoundedTimeout();
    }

    /** 设备连接状态回调 */
    public static interface OnConnectionListener {
        /**
         * 连接
         *
         * @param device
         *            蓝牙设备
         */
        public void onConnected(BluetoothDevice device);

        /**
         * 断开连接
         *
         * @param device
         *            蓝牙设备
         */
        public void onDisconnected(BluetoothDevice device);
    }

    public static interface OnConnectStateListener {
        // 用于ble
        void onConnectSuccess(BluetoothGatt gatt);
        // 用于spp
        void onConnectSuccess(BluetoothDevice device);
        // 用于edr
        void onEdrConnectSuccess(BluetoothGatt gatt);
        // 连接失败
        void onConnectFail();
    }

    /** 设备连接状态回调 */
    public static interface OnWriteListener {
        /**
         * 写回调
         *
         * @param bytes
         *            字节数
         */
        public void onWriteSuccess(int bytes);

    }

    /**
     * 获取数据发送接收器
     *
     * @return 接收器
     */
    public IBluzIO getIO();

    /**
     * 关闭gatt 的 notify
     */
    public void closeNotify();

    public void connectSpp(BluetoothDevice device);

    public void connectBle(BluetoothGatt gatt);

    public void connectEdr(BluetoothGatt gatt);

    public void removeTime();

    public void setMtu(int mtu);

    public void readIndicator(BluetoothGattCharacteristic characteristic);

    public void onWrite(BluetoothGatt gatt, BluetoothGattCharacteristic characteristic, int status);
}
