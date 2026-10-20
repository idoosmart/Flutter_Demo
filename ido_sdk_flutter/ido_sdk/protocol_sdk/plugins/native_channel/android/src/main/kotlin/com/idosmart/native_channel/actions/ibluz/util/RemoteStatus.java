package com.idosmart.native_channel.actions.ibluz.util;

/**
 * Created by InidHu on 2019/9/24.
 */

public class RemoteStatus {

    public String versionName;
    public String boardName;
    public String hardwareRev;
    public int batteryThreshold = 30;
    public int versionCode = 0;
    public int featureSupport = 0;

    @Override
    public String toString() {
        return "RemoteStatus{" +
                "versionName='" + versionName + '\'' +
                ", boardName='" + boardName + '\'' +
                ", hardwareRev='" + hardwareRev + '\'' +
                ", batteryThreshold=" + batteryThreshold +
                ", versionCode=" + versionCode +
                ", featureSupport=" + featureSupport +
                '}';
    }
}
