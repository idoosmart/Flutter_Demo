package com.example.flutter_bluetooth.dfu.parser;

import android.bluetooth.BluetoothDevice;

import com.example.flutter_bluetooth.ble.config.UUIDConfig;
import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.utils.ByteDataConvertUtil;

import java.io.UnsupportedEncodingException;

/**
 * ScannerServiceParser is responsible to parse scanning data and it check if scanned device has required service in it.
 */
public class ScannerServiceParser {
    private static final String TAG = "ScannerServiceParser";

    private static final int FLAGS_BIT = 0x01;
    private static final int SERVICES_MORE_AVAILABLE_16_BIT = 0x02;
    private static final int SERVICES_COMPLETE_LIST_16_BIT = 0x03;
    private static final int SERVICES_MORE_AVAILABLE_32_BIT = 0x04;
    private static final int SERVICES_COMPLETE_LIST_32_BIT = 0x05;
    private static final int SERVICES_MORE_AVAILABLE_128_BIT = 0x06;
    private static final int SERVICES_COMPLETE_LIST_128_BIT = 0x07;
    private static final int SHORTENED_LOCAL_NAME = 0x08;
    private static final int COMPLETE_LOCAL_NAME = 0x09;
    // private static final int COMPLETE_MANUFACTURER = -1;

    private static final byte LE_LIMITED_DISCOVERABLE_MODE = 0x01;
    private static final byte LE_GENERAL_DISCOVERABLE_MODE = 0x02;

    public static boolean isInDFUMode(byte[] data) {
        return decodeDeviceAdvData(data, new String[]{UUIDConfig.RX_UPDATE_UUID.toString(), UUIDConfig.RX_UPDATE_UUID_0XFE59.toString()});
    }

    public static boolean isInNormalMode(byte[] data) {
        return decodeDeviceAdvData(data, new String[]{UUIDConfig.RX_SERVICE_UUID.toString(), UUIDConfig.TY206_SERVICE_UUID.toString()});
    }

    /**
     * Checks if device is connectable (as Android cannot get this information directly we just check if it has GENERAL DISCOVERABLE or LIMITED DISCOVERABLE flag set) and has required service UUID in
     * the advertising packet. The service UUID may be <code>null</code>.
     * <p>
     * For further details on parsing BLE advertisement packet data see https://developer.bluetooth.org/Pages/default.aspx Bluetooth Core Specifications Volume 3, Part C, and Section 8
     * </p>
     */
    private static boolean decodeDeviceAdvData(byte[] data, String[] uuidStrings) {
        if (data == null) {
            return false;
        }

        try {
            boolean connectAble = false;
            boolean valid = false;
            int fieldLength, fieldName;
            int packetLength = data.length;
            for (int index = 0; index < packetLength; index++) {
                fieldLength = data[index];
                if (fieldLength == 0) {
                    return connectAble && valid;
                }
                fieldName = data[++index];

                if (fieldName == SERVICES_MORE_AVAILABLE_16_BIT || fieldName == SERVICES_COMPLETE_LIST_16_BIT) {
                    for (int i = index + 1; i < index + fieldLength - 1; i += 2)
                        valid = valid || decodeService16BitUUID(uuidStrings, data, i, 2);
                } else if (fieldName == SERVICES_MORE_AVAILABLE_32_BIT || fieldName == SERVICES_COMPLETE_LIST_32_BIT) {
                    for (int i = index + 1; i < index + fieldLength - 1; i += 4)
                        valid = valid || decodeService32BitUUID(uuidStrings, data, i, 4);
                } else if (fieldName == SERVICES_MORE_AVAILABLE_128_BIT || fieldName == SERVICES_COMPLETE_LIST_128_BIT) {
                    for (int i = index + 1; i < index + fieldLength - 1; i += 16)
                        valid = valid || decodeService128BitUUID(uuidStrings, data, i, 16);
                }
                if (fieldName == FLAGS_BIT) {
                    int flags = data[index + 1];
                    connectAble = (flags & (LE_GENERAL_DISCOVERABLE_MODE | LE_LIMITED_DISCOVERABLE_MODE)) > 0;
                }
                index += fieldLength - 1;
            }
            return connectAble && valid;
        } catch (Exception e) {
            Logger.e(TAG, e.getMessage());
        }
        return false;
    }

    /**
     * Decodes the device name from Complete Local Name or Shortened Local Name field in Advertisement packet. Ususally if should be done by {@link BluetoothDevice#getName()} method but some phones
     * skips that, f.e. Sony Xperia Z1 (C6903) with Android 4.3 where getName() always returns <code>null</code>. In order to show the device name correctly we have to parse it manually :(
     */
    public static String decodeDeviceName(byte[] data) {
        if (data == null) return "";
        String name = null;
        try {
            int fieldLength, fieldName;
            int packetLength = data.length;
            for (int index = 0; index < packetLength; index++) {
                fieldLength = data[index];
                if (fieldLength == 0)
                    break;
                fieldName = data[++index];

                if (fieldName == COMPLETE_LOCAL_NAME || fieldName == SHORTENED_LOCAL_NAME) {
                    name = decodeLocalName(data, index + 1, fieldLength - 1);
                    break;
                }
                index += fieldLength - 1;
            }
        } catch (Exception e) {
            Logger.e(TAG, e.getMessage());
        }

        return name;
    }

    /**
     * 解析自定义广播包
     */
    public static byte[] decodeManufacturer(byte[] data) {
        if (data == null) {
            return new byte[]{};
        }
        byte[] one = null;
        try {
            byte[] to = new byte[62];//= new byte[]{};
            int fieldLength;
            int fieldName;
            int packetLength = data.length;
            for (int index = 0; index < packetLength; index++) {
                fieldLength = data[index];
                if (fieldLength == 0)
                    break;
                fieldName = data[++index];

                // Log.p("Scance","------------------"+fieldName);
                if (fieldName == -1) {
//                Log.p("Scance","-->>>>>>>>>>>>>: "+fieldName);
//                Log.p("Scance","data.length: "+data.length);
//                Log.p("Scance","----index: "+index);
//                Log.p("Scance","---fieldLength: "+fieldLength);

                    //  ByteDataConvertUtil.BinnCat(data,to,index + 1,fieldLength - 1);
                    ByteDataConvertUtil.BinnCat(data, to, index + 1, fieldLength - 1);
                    one = new byte[fieldLength - 1];
                    ByteDataConvertUtil.BinnCat(to, one, 0, fieldLength - 1);

                    //  name = decodeLocalName(data, index + 1, fieldLength - 1);
                    break;
                }
                index += fieldLength - 1;
            }
        } catch (Exception e) {
            Logger.e(TAG, e.getMessage());
        }

        return one;
    }

    /**
     * Decodes the local name
     */
    public static String decodeLocalName(final byte[] data, final int start, final int length) {
        try {
            return new String(data, start, length, "UTF-8");
        } catch (final UnsupportedEncodingException e) {
//			Log.d(TAG, "Unable to convert the complete local name to UTF-8", e);
            return null;
        } catch (final IndexOutOfBoundsException e) {
//			Log.d(TAG, "Error when reading complete local name", e);
            return null;
        }
    }

    /**
     * check for required Service UUID inside device
     * String.format("四位十六进制：%04X", 234),
     */
    private static boolean decodeService16BitUUID(String[] uuidStrings, byte[] data, int startPosition, int serviceDataLength) {
//		String serviceUUID = Integer.toHexString(decodeUuid16(data, startPosition));//
        String serviceUUID = String.format("%04x", decodeUuid16(data, startPosition));
        return isEqual(uuidStrings, serviceUUID);
    }

    /**
     * check for required Service UUID inside device
     */
    private static boolean decodeService32BitUUID(String[] uuidStrings, byte[] data, int startPosition, int serviceDataLength) {
//		String serviceUUID = Integer.toHexString(decodeUuid16(data, startPosition + serviceDataLength - 4));
        String serviceUUID = String.format("%04x", decodeUuid16(data, startPosition + serviceDataLength - 4));
        return isEqual(uuidStrings, serviceUUID);
    }

    /**
     * check for required Service UUID inside device
     */
    private static boolean decodeService128BitUUID(String[] uuidStrings, byte[] data, int startPosition, int serviceDataLength) {
//		String serviceUUID = Integer.toHexString(decodeUuid16(data, startPosition + serviceDataLength - 4));
        String serviceUUID = String.format("%04x", decodeUuid16(data, startPosition + serviceDataLength - 4));
        return isEqual(uuidStrings, serviceUUID);
    }

    private static int decodeUuid16(final byte[] data, final int start) {
        final int b1 = data[start] & 0xff;
        final int b2 = data[start + 1] & 0xff;

        return (b2 << 8 | b1 << 0);
    }

    private static boolean isEqual(String[] uuidStrings, String targetUUIDString) {
        for (String uuid : uuidStrings) {
            String requiredUUID = uuid.substring(4, 8);
            if (targetUUIDString.equalsIgnoreCase(requiredUUID)) {

                return true;
            }
        }

        return false;
    }
}
