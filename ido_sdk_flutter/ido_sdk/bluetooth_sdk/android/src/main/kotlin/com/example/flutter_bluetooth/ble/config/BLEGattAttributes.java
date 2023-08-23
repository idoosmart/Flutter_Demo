package com.example.flutter_bluetooth.ble.config;

import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothGattService;


import java.util.UUID;

public class BLEGattAttributes {

    /** write normal BluetoothGattCharacteristic except health data */
    public static BluetoothGattCharacteristic getNormalWriteCharacteristic(BluetoothGatt gatt) {

        return getCharacteristic(gatt, UUIDConfig.SERVICE_UUID, UUIDConfig.WRITE_UUID_NORMAL);
    }

    /** write health BluetoothGattCharacteristic */
    public static BluetoothGattCharacteristic getHealthWriteCharacteristic(BluetoothGatt gatt) {

        return getCharacteristic(gatt, UUIDConfig.SERVICE_UUID, UUIDConfig.WRITE_UUID_HEALTH);
    }
    
    /** write Ppg BluetoothGattCharacteristic */
    public static BluetoothGattCharacteristic getPpgWriteCharacteristic(BluetoothGatt gatt) {
    	
    	return getCharacteristic(gatt, UUIDConfig.SERVICE_UUID, UUIDConfig.UUID_PPG);
    }
    
    /** enable/disable notify normal BluetoothGattDescriptor */
    public static boolean enablePeerDeviceNotifyNormal(BluetoothGatt gatt, boolean enable) {
//    	DebugLog.p("enablePeerDeviceNotifyNormal: " + enable);
        return enablePeerDeviceNotifyMe(gatt, UUIDConfig.NOTIFY_UUID_NORMAL, enable);
    }

    /** enable/disable notify health BluetoothGattDescriptor */
    public static boolean enablePeerDeviceNotifyHealth(BluetoothGatt gatt, boolean enable) {
//        DebugLog.p("enablePeerDeviceNotifyHealth:" + enable);
        return enablePeerDeviceNotifyMe(gatt, UUIDConfig.NOTIFY_UUID_HEALTH, enable);
    }
    
    public static boolean ppg(BluetoothGatt gatt, boolean enable) {
//    	DebugLog.p("ppg:" + enable);
    	return enablePeerDeviceNotifyMe(gatt,UUIDConfig.UUID_PPG, enable);
    }

    /** enable/disable notify BluetoothGattDescriptor 打开TX属性变更通知(我的理解：是否打开信道)*/
    private static boolean enablePeerDeviceNotifyMe(BluetoothGatt gatt, UUID uuid, boolean enable) {
        BluetoothGattCharacteristic gattCharacteristic = getCharacteristic(gatt, UUIDConfig.SERVICE_UUID, uuid);
//        StringBuilder stringBuilder=new StringBuilder();
        if ((gattCharacteristic != null) && ((BluetoothGattCharacteristic.PROPERTY_NOTIFY | gattCharacteristic.getProperties()) > 0)) {
            boolean setCharacteristicNotification=gatt.setCharacteristicNotification(gattCharacteristic, enable);
            String msg="uuid:"+uuid+",enable:"+enable+",setCharacteristicNotification:"+setCharacteristicNotification;
//            DebugLog.p(msg);
            if (uuid.equals(gattCharacteristic.getUuid())) {
                BluetoothGattDescriptor localBluetoothGattDescriptor = gattCharacteristic.getDescriptor(UUIDConfig.CLIENT_CHARACTERISTIC_CONFIG_UUID);
                if (localBluetoothGattDescriptor != null) {
                    localBluetoothGattDescriptor.setValue(enable ? BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE : BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE);
                    boolean writeDescriptor = gatt.writeDescriptor(localBluetoothGattDescriptor);
//                  LogUtil.writeBleService(msg+",writeDescriptor:"+writeDescriptor);
                    return writeDescriptor;
                }
            }
        }
        return false;
    }
    private boolean internalEnableNotifications(BluetoothGatt gatt, final BluetoothGattCharacteristic characteristic) {
		if (gatt == null || characteristic == null)
			return false;

		// Check characteristic property
		final int properties = characteristic.getProperties();
		if ((properties & BluetoothGattCharacteristic.PROPERTY_NOTIFY) == 0)
			return false;

//		DebugLog.p("gatt.setCharacteristicNotification(" + characteristic.getUuid() + ", true)");
		gatt.setCharacteristicNotification(characteristic, true);
		final BluetoothGattDescriptor descriptor = characteristic.getDescriptor(UUIDConfig.CLIENT_CHARACTERISTIC_CONFIG_UUID);
		if (descriptor != null) {
			descriptor.setValue(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE);
//			DebugLog.p("Enabling notifications for " + characteristic.getUuid());
//			DebugLog.p("gatt.writeDescriptor(" + CLIENT_CHARACTERISTIC_CONFIG_UUID + ", value=0x01-00)");
			return gatt.writeDescriptor(descriptor);
		}
		return false;
	}
    private boolean internalEnableIndications(BluetoothGatt gatt, final BluetoothGattCharacteristic characteristic) {
		if (gatt == null || characteristic == null)
			return false;

		// Check characteristic property
		final int properties = characteristic.getProperties();
		if ((properties & BluetoothGattCharacteristic.PROPERTY_INDICATE) == 0)
			return false;

//		DebugLog.p("gatt.setCharacteristicNotification(" + characteristic.getUuid() + ", true)");
		gatt.setCharacteristicNotification(characteristic, true);
		final BluetoothGattDescriptor descriptor = characteristic.getDescriptor(UUIDConfig.CLIENT_CHARACTERISTIC_CONFIG_UUID);
		if (descriptor != null) {
			descriptor.setValue(BluetoothGattDescriptor.ENABLE_INDICATION_VALUE);
//			DebugLog.p("Enabling indications for " + characteristic.getUuid());
//			DebugLog.p("gatt.writeDescriptor(" + CLIENT_CHARACTERISTIC_CONFIG_UUID + ", value=0x02-00)");
			return gatt.writeDescriptor(descriptor);
		}
		return false;
	}
    private static BluetoothGattCharacteristic getCharacteristic(BluetoothGatt gatt, UUID serviceId, UUID characteristicId) {
//    	DebugLog.p("serviceId:"+serviceId+",characteristicId:"+characteristicId);
//    	LogUtil.writeBleService("BluetoothGattCharacteristic "+"serviceId:"+serviceId+",characteristicId:"+characteristicId);
        if (gatt == null) {
//        	DebugLog.p("gatt is nullllll");
//        	LogUtil.writeBleService("BluetoothGattCharacteristic gatt is nullllll");
            return null;
        }
        BluetoothGattService service = gatt.getService(serviceId);
        if (service == null) {
//        	DebugLog.p("service is nullllll");
//        	LogUtil.writeBleService("BluetoothGattCharacteristic service is nullllll");
           return null;
        }
        BluetoothGattCharacteristic c = service.getCharacteristic(characteristicId);
        return c;
    }
}