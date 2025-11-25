package com.example.flutter_bluetooth.ble.device;


import com.example.flutter_bluetooth.logger.Logger;
import com.example.flutter_bluetooth.utils.ByteDataConvertUtil;

public class BLEPairData {
    private boolean isEncEnable;
    private boolean isBusinessBind;
    private boolean isSupportRepeatPair;
    private boolean isLEPaired;
    private boolean isIDOLEPairData;

    public BLEPairData(byte[] value) {
        try {
            if (value.length > 6) {
                isIDOLEPairData =
                        (value[1] & 0xff) == 0x36 && (value[2] & 0xff) == 0x58 && (value[3] & 0xff) == 0x72 && (value[4] & 0xff) == 0x14;
                isEncEnable = isIDOLEPairData && ((value[0] & 0xff) == 0x01);
                isBusinessBind = isIDOLEPairData && ((value[5] & 0xff) == 0x01);
                isSupportRepeatPair = isIDOLEPairData && ((value[6] & 0xff) == 0x01);
                if (value.length > 7) {
                    isLEPaired = isIDOLEPairData && ((value[7] & 0xff) == 0x01);
                }

            }
        } catch (Exception e) {
            Logger.p( "BLEPairData Exception: " + ByteDataConvertUtil.bytesToHexString(value) + ", e: " + e);
        }
    }

    public boolean isEncEnable() {
        return isEncEnable;
    }

    public boolean isBusinessBind() {
        return isBusinessBind;
    }

    public boolean isSupportRepeatPair() {
        return isSupportRepeatPair;
    }

    public boolean isLEPaired() {
        return isLEPaired;
    }

    public boolean isValidLEPairData() {
        return isIDOLEPairData;
    }
}
