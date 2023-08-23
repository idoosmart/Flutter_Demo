package com.example.flutter_bluetooth.utils;

import android.text.TextUtils;


import com.example.flutter_bluetooth.dfu.BLEDevice;
import com.example.flutter_bluetooth.dfu.BleDFUConstants;
import com.example.flutter_bluetooth.logger.Logger;

import java.util.Locale;

public class MacAdd1Utils {

    /**
     * 处理mac地址+1机制（有些手环如果处在ota模式下， 电量耗完之后，然后充电重启，mac地址会+1）
     */
    public static boolean isMacAddressAdd1(String macAddressAdd1,String macAddressAdd2, BLEDevice scanDevice){
        if (TextUtils.isEmpty(macAddressAdd1) || TextUtils.isEmpty(scanDevice.mDeviceAddress)){
            return false;
        }

//        if (!scanDevice.mIsInDfuMode){
//            return false;
//        }

        if (scanDevice.mDeviceAddress.equalsIgnoreCase(macAddressAdd1)){
            return true;
        }
        if (scanDevice.mDeviceAddress.equalsIgnoreCase(macAddressAdd2)){
            return true;
        }
        return false;
    }

    /**
     * mac+1,这个方法只处理了后2位
     * @param mac
     * @return
     */
    public static String getAdd1MacAddress(String mac){
        String lastChar = mac.substring(mac.length() - 1).toUpperCase(Locale.getDefault());
        String lastChar1 = mac.substring(mac.length()- 2,mac.length()-1).toUpperCase(Locale.getDefault());
        mac = mac.substring(0, mac.length() - 2);
        if("F".equals(lastChar)){
            lastChar = "0";
            if("F".equals(lastChar1)){
                lastChar1 = "0";
            }else {
                int tempChar = Integer.parseInt(lastChar1, 16) + 1;
                lastChar1 = Integer.toHexString(tempChar).toUpperCase(Locale.getDefault());
            }
        } else {
            int tempChar = Integer.parseInt(lastChar, 16) + 1;
            lastChar = Integer.toHexString(tempChar).toUpperCase(Locale.getDefault());
        }
        Logger.p(BleDFUConstants.LOG_TAG , "macAddressAdd1:"+(mac + lastChar1+lastChar));
        return (mac + lastChar1+lastChar);
    }

    /**
     * mac+1,满了会往前进  比如：00：ff +1 =  01:00
     * @param macString
     * @return
     */
    public static String getAdd2MacAddress(String macString) {
        if (macString.isEmpty()) {
            return "00:00:00:00:00:00";
        }
        String[] splitMac = macString.split(":");
        if (splitMac.length != 6) {
            return "00:00:00:00:00:00";
        }
        byte[] mac = new byte[splitMac.length];
        for (int i = 0; i < splitMac.length; i++) {
            char[] hexChars = splitMac[i].toCharArray();
            if (hexChars.length == 1) {
                mac[5 - i] = (byte) (charToByte(hexChars[0]));
            } else {
                mac[5 - i] = (byte) (charToByte(hexChars[0]) << 4 | charToByte(hexChars[1]));
            }
            System.out.println(String.format("%02x",mac[5-i]));
        }

        long mac_tmp_high = ((mac[5] << 16)&0xff0000) + ((mac[4] << 8)&0xff00) + (mac[3]&0xff);
        long mac_tmp_low = ((mac[2] << 16)&0xff0000) + ((mac[1] << 8)&0xff00) + (mac[0]&0xff);
        System.out.println(mac_tmp_low);
        mac_tmp_low += 1;
        System.out.println(mac_tmp_low);

        if (mac_tmp_low > 0xffffff) {
            mac_tmp_high += 1;
        }
        mac[5] = (byte) ((mac_tmp_high >> 16) & 0xff);
        mac[4] = (byte) ((mac_tmp_high >> 8) & 0xff);
        mac[3] = (byte) ((mac_tmp_high) & 0xff);

        System.out.println(mac_tmp_low);
        mac[2] = (byte) ((mac_tmp_low >> 16) & 0xff);
        mac[1] = (byte) ((mac_tmp_low >> 8) & 0xff);
        mac[0] = (byte) ((mac_tmp_low) & 0xff);
        return String.format("%02X:%02X:%02X:%02X:%02X:%02X", mac[5], mac[4], mac[3], mac[2], mac[1], mac[0]);
    }

    private static byte charToByte(char c) {
        return (byte) "0123456789ABCDEF".indexOf(c);
    }
}
