package com.idosmart.native_channel.common;

/**
 * Created by Zhouzj on 2017/12/22.
 * 升级参数
 */

public class BleDFUConfig {
    public static final int PLATE_FORM_AUTO = -1;
    public static final int PLATFORM_NORDIC = 0;
    public static final int PLATFORM_NORDIC_ZEPHYR = 1;
    public static final int PLATFORM_REALTEK = 10;
    public static final int PLATFORM_CYPRESS = 20;
    public static final int PLATFORM_APOLLO3 = 30;
    public static final int PLATFORM_ACTIONS = 91;//炬芯 IDW29新增升级方式
    public static final int PLATFORM_SICHE = 99;
    public static final int PLATFORM_SICHE_NOR = 98;
    private String filePath;

    private String macAddress;


    private String deviceId;

    private int PRN;

    private int platform = PLATE_FORM_AUTO;

    private boolean isDFU = false;//是否在升级模式下



    /**
     * 在重试过程中，如果多次升级失败，是否需要重启蓝牙
     */
    private boolean isNeedReOpenBluetoothSwitchIfFailed = true;

    /**
     * 最大重试次数
     */
    private int maxRetryTime = 6;

    /**
     * RTK平台的OTA，在升级之前是否需要授权
     */
    private boolean isNeedAuth = false;

    public static final int OTA_MODE_NORMAL_FUNCTION = 0;
    public static final int OTA_MODE_SILENT_FUNCTION = 16;
    public static final int OTA_MODE_SILENT_EXTEND_FLASH = 17;
    public static final int OTA_MODE_SILENT_NO_TEMP = 18;
    public static final int OTA_MODE_AUTOMATIC = 255;
    /**
     * RTK平台的OTA，模式
     */
    private int otaWorkMode = OTA_MODE_NORMAL_FUNCTION;

    public String getFilePath() {
        return filePath;
    }

    /**
     * 升级包路径;
     * <br/>
     * the file path;
     */
    public BleDFUConfig setFilePath(String filePath) {
        this.filePath = filePath;
        return this;
    }

    public String getMacAddress() {
        return macAddress;
    }

    /**
     * mac地址
     * <br/>
     * the device mac address;
     */
    public BleDFUConfig setMacAddress(String macAddress) {
        this.macAddress = macAddress;
        return this;
    }

    public String getDeviceId() {
        return deviceId;
    }

    /**
     * 设备ID
     * <br/>
     * the device id;
     */
    public BleDFUConfig setDeviceId(String deviceId) {
        this.deviceId = deviceId;
        return this;
    }

    public int getPRN() {
        return PRN;
    }

    public BleDFUConfig setPRN(int PRN) {
        this.PRN = PRN;
        return this;
    }

    public boolean isNeedReOpenBluetoothSwitchIfFailed() {
        return isNeedReOpenBluetoothSwitchIfFailed;
    }

    public BleDFUConfig setNeedReOpenBluetoothSwitchIfFailed(boolean needReOpenBluetoothSwitchIfFailed) {
        isNeedReOpenBluetoothSwitchIfFailed = needReOpenBluetoothSwitchIfFailed;
        return this;
    }

    public int getMaxRetryTime() {
        return maxRetryTime;
    }

    public BleDFUConfig setMaxRetryTime(int maxRetryTime) {
        this.maxRetryTime = maxRetryTime;
        return this;
    }

    public boolean isNeedAuth() {
        return isNeedAuth;
    }

    public BleDFUConfig setNeedAuth(boolean needAuth) {
        isNeedAuth = needAuth;
        return this;
    }

    public int getPlatform() {
        return platform;
    }

    public BleDFUConfig setPlatform(int platform) {
        this.platform = platform;
        return this;
    }

    public boolean getIsDfu() {
        return isDFU;
    }

    public BleDFUConfig setIsDfu(boolean misDfu) {
        this.isDFU = misDfu;
        return this;
    }

    public int getOtaWorkMode() {
        return otaWorkMode;
    }

    public BleDFUConfig setOtaWorkMode(int otaWorkMode) {
        this.otaWorkMode = otaWorkMode;
        return this;
    }

    @Override
    public String toString() {
        return "BleDFUConfig{" +
                "filePath='" + filePath + '\'' +
                ", macAddress='" + macAddress + '\'' +
                ", deviceId='" + deviceId + '\'' +
                ", PRN=" + PRN +
                ", platform=" + platform +
                ", isDFU=" + isDFU +
                ", isNeedReOpenBluetoothSwitchIfFailed=" + isNeedReOpenBluetoothSwitchIfFailed +
                ", maxRetryTime=" + maxRetryTime +
                ", isNeedAuth=" + isNeedAuth +
                ", otaWorkMode=" + otaWorkMode +
                '}';
    }
}
