package com.example.flutter_bluetooth.ble.config;

import java.util.UUID;

/**
 * Created by asus on 2017/9/29.
 */

public class UUIDConfig {

    public static final UUID SPP_UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");
    public static final UUID UUID_PPG = UUID.fromString("00000aF4-0000-1000-8000-00805f9b34fb");//ppg

    public static final UUID CLIENT_CHARACTERISTIC_CONFIG_UUID = UUID.fromString("00002902-0000-1000-8000-00805f9b34fb");



    public static final UUID RX_UPDATE_UUID = UUID.fromString("00001530-1212-efde-1523-785feabcd123");// 升级
    public static final UUID RX_UPDATE_UUID_0XFE59 = UUID.fromString("0000fe59-0000-1000-8000-00805f9b34fb");// 升级
    public static final UUID RX_UPDATE_UUID_0X0203 = UUID.fromString("00010203-0405-0607-0809-0a0b0c0d1912");// realme IDw02 0101升级模式

    public static final UUID NODIC_DFU_VERSION_UUID       = new UUID(0x000015341212EFDEL, 0x1523785FEABCD123L);



    public static final UUID SERVICE_UUID = UUID.fromString("00000aF0-0000-1000-8000-00805f9b34fb");//主服务(Characteristic的集合)

    /** write data except health data */
    public static final UUID WRITE_UUID_NORMAL = UUID.fromString("00000aF6-0000-1000-8000-00805f9b34fb");//发送正常数据
    /** notify data except health data */
    public static final UUID NOTIFY_UUID_NORMAL = UUID.fromString("00000aF7-0000-1000-8000-00805f9b34fb");//接收正常数据

    /** write health data */
    public static final UUID WRITE_UUID_HEALTH = UUID.fromString("00000aF1-0000-1000-8000-00805f9b34fb");//发送健康数据
    /** notify health data */
    public static final UUID NOTIFY_UUID_HEALTH = UUID.fromString("00000aF2-0000-1000-8000-00805f9b34fb");//接收健康数据
    public static final UUID RX_SERVICE_UUID = UUID.fromString("00000af0-0000-1000-8000-00805f9b34fb");// 扫描
    public static final UUID TY206_SERVICE_UUID = UUID.fromString("0000FD50-0000-1000-8000-00805f9b34fb");//206涂鸦新增扫描

    public static final UUID SERVICE_UUID_HENXUAN = UUID.fromString("00000800-0000-1000-8000-00805f9b34fb");//主服务(Characteristic的集合)
    //恒玄平台
    public static final UUID WRITE_UUID_HENXUAN = UUID.fromString("00000814-0000-1000-8000-00805f9b34fb");//发送正常数据
    //恒玄平台
    /** notify data except health data */
    public static final UUID NOTIFY_UUID_HENXUAN = UUID.fromString("00000813-0000-1000-8000-00805f9b34fb");//接收正常数据

    //韩国vc客户
    public static final UUID SERVICE_UUID_VC = UUID.fromString("2D420001-6569-6464-6163-6563696F562D");//主服务(Characteristic的集合)
    //恒玄平台
    public static final UUID WRITE_UUID_VC = UUID.fromString("2D420003-6569-6464-6163-6563696F562D");//发送正常数据
    //恒玄平台
    /** notify data except health data */
    public static final UUID NOTIFY_UUID_VC = UUID.fromString("2D420002-6569-6464-6163-6563696F562D");//接收正常数据

    //BOAT定制固件特有uuid
//    public static final UUID SERVICE_UUID = UUID.fromString("00000aF4-0000-1000-8000-00805f9b34fb");//主服务(Characteristic的集合)
//        /** write data except health data */
//    public static final UUID WRITE_UUID_NORMAL = UUID.fromString("00000aFA-0000-1000-8000-00805f9b34fb");//发送正常数据
//        /** notify data except health data */
//    public static final UUID NOTIFY_UUID_NORMAL = UUID.fromString("00000aFB-0000-1000-8000-00805f9b34fb");//接收正常数据
//        /** write health data */
//    public static final UUID WRITE_UUID_HEALTH = UUID.fromString("00000aF5-0000-1000-8000-00805f9b34fb");//发送健康数据
//        /** notify health data */
//    public static final UUID NOTIFY_UUID_HEALTH = UUID.fromString("00000aF6-0000-1000-8000-00805f9b34fb");//接收健康数据
//
//    public static final UUID RX_SERVICE_UUID = UUID.fromString("00000af4-0000-1000-8000-00805f9b34fb");// 扫描

}
