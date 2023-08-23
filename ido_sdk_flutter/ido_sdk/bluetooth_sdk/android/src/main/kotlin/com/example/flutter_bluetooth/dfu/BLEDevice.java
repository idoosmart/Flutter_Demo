package com.example.flutter_bluetooth.dfu;

import java.io.Serializable;

public class BLEDevice implements Serializable, Comparable<BLEDevice> {
	private static final long serialVersionUID = -5217710157640312976L;

	/**
	 * 从手机蓝牙配对列表中获取的设备
	 */
	public static final int TYPE_FROM_PHONE_PAIRED = -1;
	public static final int TYPE_INVALID = 0;
	/**
	 * 手表
	 */
	public static final int TYPE_WATCH = 1;
	/**
	 * 手环
	 */
	public static final int TYPE_BRACELET = 2;
	/**
	 * 设备名称
	 * <br/>
	 * Device name
	 */
	public String mDeviceName;
	/**
	 * 设备Mac地址
	 * <br/>
	 * Device mac address
	 */
	public String mDeviceAddress;
	/**
	 * 信号强度
	 * <br/>
	 * signal strength
	 */
	public int mRssi;
	/**
	 * 设备ID
	 * <br/>
	 * Device ID
	 */
	public int mDeviceId;

	public boolean mIsInDfuMode;

	/**
	 * 设备类型
	 * 1是手表，2是手环，0表示无效/不存在
	 */
	public int type;

	public int bootload_version;//nordic平台bootloader版本信息

	/**
	 * 这个参数暂时没有用到
	 */
	@Deprecated
	public int version = -1;
	@Deprecated
	public OTAFactoryDeviceInfo otaFactoryDeviceInfo;
	public static class OTAFactoryDeviceInfo implements Serializable{

		/**
		 * 工厂工具升级时，特殊固件包需要的参数
		 */
		public int version = 0;
		public int bootload_version = 0;
		public int special_version = 0;
		public int flash_bin_version = 0;
		public int internal_version = 0;

		@Override
		public String toString() {
			return "OTAFactoryDeviceInfo{" +
					"version=" + version +
					", bootload_version=" + bootload_version +
					", special_version=" + special_version +
					", flash_bin_version=" + flash_bin_version +
					", internal_version=" + internal_version +
					'}';
		}
	}

	@Override
	public int compareTo(BLEDevice another) {
		return Integer.compare(another.mRssi, mRssi);
	}
	@Override
	public boolean equals(Object o) {
		if(o==null){
			return false;
		}
		BLEDevice d=(BLEDevice) o;
		return mDeviceAddress.equals(d.mDeviceAddress);
	}

	@Override
	public String toString() {
		return "BLEDevice{" +
				"mDeviceName='" + mDeviceName + '\'' +
				", mDeviceAddress='" + mDeviceAddress + '\'' +
				", mRssi=" + mRssi +
				", mDeviceId=" + mDeviceId +
				", mIsInDfuMode=" + mIsInDfuMode +
				", type=" + type +
				", bootload_version=" + bootload_version +
				", version=" + version +
				", otaFactoryDeviceInfo=" + otaFactoryDeviceInfo +
				'}';
	}

	public String toFactoryString() {
		return "BLEDevice{" +
				"mDeviceName='" + mDeviceName + '\'' +
				", mDeviceAddress='" + mDeviceAddress + '\'' +
				", mRssi=" + mRssi +
				", mDeviceId=" + mDeviceId +
				", mIsInDfuMode=" + mIsInDfuMode +
				", type=" + type +
				", otaFactoryDeviceInfo=" + otaFactoryDeviceInfo +
				'}';
	}
}
