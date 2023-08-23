package com.example.flutter_bluetooth.dfu.parser;

import android.util.Log;

import com.example.flutter_bluetooth.logger.Logger;

/**
 * DFUServiceParser is responsible to parse sccanning data and it check if scanned device has DFU service in it
 */
public class DFUServiceParser {
	private static final String TAG = "DFUServiceParser";
	private static final int SERVICE_CLASS_128BIT_UUID = 0x06;
	private static final int SERVICE_CLASS_16BIT_UUID = 0x02;
	private static final String DFU_SERVICE_128BIT_UUID = "2148"; // 0x1530
	private static final String DFU_SERVICE_16BIT_UUID = "-289"; // 0xfe59

	/**
	 * It will check field name Service Class UUID with value for 128-bit-Service-UUID = {6}
	 */
	public static boolean decodeDFUAdvData(byte[] data){
		if (data == null){
			return false;
		}

		try {
			int fieldLength, fieldName;
			int packetLength = data.length;
			for (int index = 0; index < packetLength; index++) {
				fieldLength = data[index];
				if (fieldLength == 0) {
					//NodicDFUManager.log(TAG, "index: " + index + " No more data exist in Advertisement packet");
					//	Log.p(TAG, "index: " + index + " No more data exist in Advertisement packet");
					return false;
				}
				fieldName = data[++index];
				//NodicDFUManager.log(TAG, "fieldName: " + fieldName + " Filed Length: " + fieldLength);
				//	Log.p(TAG, "fieldName: " + fieldName + " Filed Length: " + fieldLength);
				if (fieldName == SERVICE_CLASS_128BIT_UUID) {
					//NodicDFUManager.log(TAG, "index: " + index + " Service class 128 bit UUID exist");
					//Log.p(TAG, "index: " + index + " Service class 128 bit UUID exist");
					return decodeService128BitUUID(data, index + 1, fieldLength - 1);

				}else if (fieldName == SERVICE_CLASS_16BIT_UUID){
					return decodeService16BitUUID(data, index + 1, fieldLength -1);
				}

				index += fieldLength - 1;
			}
		}catch (Exception e){
			Logger.e(TAG,e.getMessage());
		}


		return false;
	}

	/**
	 * check for required DFU Service UUID = 0x1530 or in decimal 2148 inside 128 bit uuid
	 */
	private static boolean decodeService128BitUUID(byte[] data, int startPosition, int serviceDataLength) throws Exception{
		//NodicDFUManager.log(TAG, "StartPosition: " + startPosition + " Data length: " + serviceDataLength);
	    Log.d(TAG,"StartPosition: " + startPosition + " Data length: " + serviceDataLength);
	    if (data == null || data.length == 0){
	    	return false;
		}

		if (startPosition + serviceDataLength < 4){
	    	return false;
		}

		if ((startPosition + serviceDataLength -4) > data.length){
	    	return false;
		}


		String ServiceUUID = Byte.toString(data[startPosition + serviceDataLength - 3]) + Byte.toString(data[startPosition + serviceDataLength - 4]);
		if (ServiceUUID.equals(DFU_SERVICE_128BIT_UUID)) {
			return true;
		}

		return false;
	}

	/**
	 * check for required DFU Service UUID = 0x1530 or in decimal 2148 inside 128 bit uuid
	 */
	private static boolean decodeService16BitUUID(byte[] data, int startPosition, int serviceDataLength) throws Exception{
		//NodicDFUManager.log(TAG, "StartPosition: " + startPosition + " Data length: " + serviceDataLength);
		Log.d(TAG,"StartPosition: " + startPosition + " Data length: " + serviceDataLength);
		if (data == null || data.length == 0){
			return false;
		}

		if (serviceDataLength < 2){
			return false;
		}


		String ServiceUUID = Byte.toString(data[startPosition + 1]) + Byte.toString(data[startPosition]);
		if (ServiceUUID.equals(DFU_SERVICE_16BIT_UUID)) {
			return true;
		}

		return false;
	}

}
