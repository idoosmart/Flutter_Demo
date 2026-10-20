package com.idosmart.native_channel.actions.ibluz.factory;

import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.util.Log;


import com.idosmart.native_channel.actions.ibluz.device.bluzdevice.BluzDeviceBle;
import com.idosmart.native_channel.actions.ibluz.device.bluzdevice.BluzDeviceEdrNew;
import com.idosmart.native_channel.actions.ibluz.device.bluzdevice.BluzDeviceSpp;

import java.util.Map;
import java.util.UUID;

public class BluzDeviceFactory {
    private static final String TAG = "BluzDeviceFactory";


    public static class ConnectionType {
        /** SPP */
        public static final String SPP = "SPP";
        /** BLE */
        public static final String BLE = "BLE";
        /** SPP_ONLY */
        public static final String SPP_ONLY = "SPP_ONLY";
        /** BLE and BR */
        public static final String BLE_BR = "BLE_BR";
        /** EDR **/
        public static final String EDR = "EDR";
    }

    public static class KeyUUIDS {
        public static final String keyConfigurationUUID = "keyConfigurationUUID";
        public static final String keyServiceUUID = "keyServiceUUID";
        public static final String keyReadCharacteristicUUID = "keyReadCharacteristicUUID";
        public static final String keyWriteCharacteristicUUID = "keyWriteCharacteristicUUID";
    }

    /** 连接状态 */
    public static class ConnectionState {
        public static final int A2DP_CONNECTED = 1;
        public static final int A2DP_CONNECTING = 2;
        public static final int A2DP_DISCONNECTED = 3;
        public static final int A2DP_FAILURE = 4;
        public static final int A2DP_PAIRING = 5;

        public static final int SPP_CONNECTED = 11;
        public static final int SPP_CONNECTING = 12;
        public static final int SPP_DISCONNECTED = 13;
        public static final int SPP_FAILURE = 14;
    }

    public static class DiscoveryType{
        public static final int DISCOVERY_NORMAL = 1;
        public static final int DISCOVERY_A2DP = 2;
    }

    private static UUID sUUID = null;
    private static Map<String,UUID> bleUUIDs = null;
    private static Map<String, UUID> mEdrUUIDs = null;

    /**
     * 设置自定义UUID
     *
     * @param uuid
     *            SPP协议的UUID
     */
    public static void setUUID(UUID uuid) {
        sUUID = uuid;
    }

    /**
     * 设置自定义UUID
     *
     * @param uuids
     *            BLE协议的UUIDs
     */
    public static void setUUID(Map<String,UUID> uuids) {
        bleUUIDs = uuids;
    }

//    /**
//     * 设置自定义 edr UUID
//     * @param uuids
//     * 	         EDR协议的UUIDs
//     * @param isEDR
//     * 			 是否为EDR
//     */
//    public static void setUUID(Map<String, UUID> uuids, boolean isEDR) {
//        Log.e("setUUID", isEDR + "");
//        if (isEDR) {
//            mEdrUUIDs = uuids;
//        } else {
//            setUUID(uuids);
//        }
//    }

    /**
     * 获取蓝牙连接设备
     *
     * @param context
     * @param type
     *            设备协议类型
     * @return
     */
    public static IBluzDevice getDevice(Context context, String type) {
        if (BluetoothAdapter.getDefaultAdapter() == null) {
            Log.e("BluzDeviceFactory", "BluetoothAdapter.getDefaultAdapter() == null");
            return null;
        }
        if (type.equals(ConnectionType.BLE)) {
            Log.i(TAG, "connect type: ble");
            return new BluzDeviceBle(context);
        } else if (type.equals(ConnectionType.SPP)) {
            Log.i(TAG, "connect type: spp");
            return new BluzDeviceSpp(context);
        } else if (type.equals(ConnectionType.EDR)) {
            Log.i(TAG, "connect type: edr");
            return new BluzDeviceEdrNew(context);
        }
        return null;
    }
}
