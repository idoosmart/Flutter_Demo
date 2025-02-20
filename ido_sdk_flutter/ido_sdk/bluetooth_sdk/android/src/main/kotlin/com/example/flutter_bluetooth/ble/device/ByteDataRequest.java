package com.example.flutter_bluetooth.ble.device;

import android.bluetooth.BluetoothGattCharacteristic;

/**
 * 发送数据类
 */
public class ByteDataRequest {
    public static final int TYPE_IDO = 0;
    public static final int TYPE_HENXUAN = 1;
    public static final int TYPE_VC = 2;
    private byte[] sendData;
    private String uuid;
    private int platform = TYPE_IDO;// 0 ido 数据  ，1henxuan 数据
    private int writeType = BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT;
    public byte[] getSendData() {
        return sendData;
    }

    public void setSendData(byte[] sendData) {
        this.sendData = sendData;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public int getPlatform() {
        return platform;
    }

    public void setPlatform(int platform) {
        this.platform = platform;
    }

    public int getWriteType() {
        return writeType;
    }

    public void setWriteType(int writeType) {
        this.writeType = writeType;
    }


}
