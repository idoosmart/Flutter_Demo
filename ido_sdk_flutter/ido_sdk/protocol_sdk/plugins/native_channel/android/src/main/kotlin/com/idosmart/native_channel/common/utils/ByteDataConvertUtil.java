package com.idosmart.native_channel.common.utils;

import android.util.Log;


import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Array;

public class ByteDataConvertUtil {

    private static final char[] HEX_CHARS = "0123456789ABCDEF".toCharArray();
	private static String CHAR_ENCODE = "UTF-8";
    public static byte Int2Byte(int num) {
        return (byte) (num & 0x000000FF);
    }

    public static int Byte2Int(byte byteNum) {

        return byteNum >= 0 ? byteNum : (128 + (128 + byteNum));
    }

    public static void BinnCat(byte[] from, byte to, int offset, int len) {
        int max = offset + len;
        int min = offset;
        for (int i = min, j = 0; i < max; i++, j++) {
            to = from[j];
        }
    }

    /** 提取index开始长度为len的数据 */
    public static void BinnCat(byte[] from, byte[] to, int index, int len) {
        int min = index;
        for (int i = 0, j = min; i < len; i++, j++) {
            to[i] = from[j];
        }
    }

    /***
     * long转换为byte数组
     * 
     * @param from
     * @param len
     * @return
     */
    public static byte[] LongToBin(long from, int len) {
        byte[] to = new byte[len];
        int max = len;

        for (int i_move = max - 1, i_to = 0; i_move >= 0; i_move--, i_to++) {
            to[i_to] = (byte) (from >> (8 * i_move));
        }

        return to;
    }

    /***
     * 将long转换成Byte 第几个到多长
     * 
     * @param from
     * @param to
     * @param offset
     * @param len
     */
    public static void LongToBin(long from, byte[] to, int offset, int len) {
        int max = len;
        int min = offset;

        for (int i_move = max - 1, i_to = min; i_move >= 0; i_move--, i_to++) {
            to[i_to] = (byte) (from >> (8 * i_move));
        }
    }

    /***
     * int型转换成byte数组
     * 
     * @param from
     * @param len
     * @return
     */
    public static byte[] IntToBin(int from, int len) {
        byte[] to = new byte[len];
        int max = len;

        for (int i_move = max - 1, i_to = 0; i_move >= 0; i_move--, i_to++) {
            to[i_to] = (byte) (from >> (8 * i_move));
        }

        return to;
    }

    /***
     * 转换int保存到byte的第几到几
     * 
     * @param from
     * @param to
     * @param offset
     * @param len
     * @return
     */
    public static byte[] IntToBin(int from, byte[] to, int offset, int len) {
        int max = len;
        int min = offset;

        for (int i_move = max - 1, i_to = min; i_move >= 0; i_move--, i_to++) {
            to[i_to] = (byte) (from >> (8 * i_move));
        }

        return to;
    }

    /***
     * byte数据的第几到几，转换为long
     * 
     * @param from
     * @param offset
     * @param len
     * @return
     */
    public static long BinToLong(byte[] from, int offset, int len) {
        long to;
        int min = offset;
        to = 0;
        for (int i_move = len - 1, i_from = min; i_move >= 0; i_move--, i_from++) {
            to = to << 8 | (from[i_from] & 0xff);
        }
        return to;
    }

    /***
     * 将byte的第几到几，转换成int
     * 
     * @param from
     * @param offset
     * @param len
     * @return
     */
    public static int BinToInt(byte[] from, int offset, int len) {
        int to = 0;
        int min = offset;
        to = 0;

        for (int i_move = len - 1, i_from = min; i_move >= 0; i_move--, i_from++) {
            to = to << 8 | (from[i_from] & 0xff);
        }
        return to;
    }

    /***
     * 将MAC地址转换为byte数组
     * 
     * @param mac
     * @return
     */
    public static byte[] getMacBytes(String mac) {
        byte[] macBytes = new byte[6];
        String[] strArr = mac.split(":");

        for (int i = 0; i < strArr.length; i++) {
            int value = Integer.parseInt(strArr[i], 16);
            macBytes[i] = (byte) value;
        }
        return macBytes;
    }

    public static String getStrBytes(byte[] data, int offset, int len) {
        if (data.length < (offset + len))
            return null;
        String str = "";
        for (int i = 0; i < len; i++) {
            str += String.format("%02X", data[offset + i]);
        }
        return str;
    }


    public static String bytesToHexPerformance(byte[] bytes) {
        try {
            if (bytes == null) return "";
            if (bytes.length == 0) return "";

            final int len = bytes.length;
            // 计算最终字符串长度：每字节2字符 + 每字节1空格（最后字节不加空格）
            final int totalChars = len * 3 - 1;
            char[] hexChars = new char[totalChars];

            // 处理除最后一个字节外的所有字节
            int pos = 0;
            for (int i = 0; i < len - 1; i++) {
                int v = bytes[i] & 0xFF;
                // 写入两个十六进制字符
                hexChars[pos++] = HEX_CHARS[v >>> 4];
                hexChars[pos++] = HEX_CHARS[v & 0x0F];
                // 添加空格分隔符
                hexChars[pos++] = ' ';
            }

            // 单独处理最后一个字节（不加空格）
            int last = bytes[len - 1] & 0xFF;
            hexChars[pos++] = HEX_CHARS[last >>> 4];
            hexChars[pos] = HEX_CHARS[last & 0x0F];

            return new String(hexChars);
        } catch (Exception e) {
            e.printStackTrace();

        }
        return "";
    }

    public static String bytesToHexPerformance(byte[] bytes, int length) {
        try {
            if (bytes == null || bytes.length == 0) {
                return "";
            }
            int len = length > 0 ? Math.min(bytes.length, length) : bytes.length;
            // 计算最终字符串长度：每字节2字符 + 每字节1空格（最后字节不加空格）
            final int totalChars = len * 3 - 1;
            char[] hexChars = new char[totalChars];

            // 处理除最后一个字节外的所有字节
            int pos = 0;
            for (int i = 0; i < len - 1; i++) {
                int v = bytes[i] & 0xFF;
                // 写入两个十六进制字符
                hexChars[pos++] = HEX_CHARS[v >>> 4];
                hexChars[pos++] = HEX_CHARS[v & 0x0F];
                // 添加空格分隔符
                hexChars[pos++] = ' ';
            }

            // 单独处理最后一个字节（不加空格）
            int last = bytes[len - 1] & 0xFF;
            hexChars[pos++] = HEX_CHARS[last >>> 4];
            hexChars[pos] = HEX_CHARS[last & 0x0F];

            return new String(hexChars);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public static String bytesToHex(byte[] bytes) {
        if (bytes == null) return null;
        int len = bytes.length;
        char[] hexChars = new char[len * 2];
        for (int i = 0; i < len; i++) {
            int v = bytes[i] & 0xFF; // 确保无符号
            hexChars[i * 2] = HEX_CHARS[v >>> 4]; // 高4位
            hexChars[i * 2 + 1] = HEX_CHARS[v & 0x0F]; // 低4位
        }
        return new String(hexChars);
    }

    /**
     * byte数组转换成16进制字符串
     * 
     * @param src
     * @return
     */
    public static String bytesToHexString(byte[] src) {
        StringBuilder stringBuilder = new StringBuilder();
        if (src == null || src.length <= 0) {
            return null;
        }
        //缩减文件传输内容日志打印
        if (isNeedReduceLog(src)) {
            return bytesToHexString(src, 20);
        }
        if (src.length >= 2) {
            if ((src[0] & 0xff) == 0xd1 && (src[1] & 0xff) == 0x02) {
                return bytesToHexString(src, 20);
            }
        }
        for (int i = 0; i < src.length; i++) {
            int v = src[i] & 0xFF;
            String hv = Integer.toHexString(v);

            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
            stringBuilder.append(" ");
        }
        return stringBuilder.toString();
    }

    public static boolean isNeedReduceLog(byte[] src){
        //A5 5A 00 02 D1 02
        if (src != null && src.length >= 6) {
            if ((src[0] & 0xff) == 0xA5 && (src[1] & 0xff) == 0x5A &&  (src[4] & 0xff) == 0xD1 && (src[5] & 0xff) == 0x02) {
                return true;
            }
            if ((src[0] & 0xff) == 0xd1 && (src[1] & 0xff) == 0x02) {
                return true;
            }
        }
        return false;
    }

    /**
     * byte数组转换成16进制字符串
     *
     * @param src
     * @return
     */
    public static String bytesToHexString(byte[] src,long length) {
        StringBuilder stringBuilder = new StringBuilder();
        if (src == null || src.length <= 0 || length <= 0|| length > src.length) {
            return null;
        }
        //缩减文件传输内容日志打印
        if (src.length >= 2) {
            if ((src[0] & 0xff) == 0xd1 && (src[1] & 0xff) == 0x02) {
                return bytesToHexString(src, 20);
            }
        }
        for (int i = 0; i < length; i++) {
            int v = src[i] & 0xFF;
            String hv = Integer.toHexString(v);

            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
            stringBuilder.append(" ");
        }
        return stringBuilder.toString();
    }

    /**
     * byte数组转换成16进制字符串
     *
     * @param src
     * @return
     */
    public static String bytesToHexStringSpp(byte[] src) {
        StringBuilder stringBuilder = new StringBuilder();
        if (src == null || src.length <= 0) {
            return null;
        }
        //缩减文件传输内容日志打印
        if (src.length >= 4) {
            if ((src[2] & 0xff) == 0xd2 && (src[3] & 0xff) == 0x02) {
                return bytesToHexString(src, 20);
            }
        }
        for (int i = 0; i < src.length; i++) {
            int v = src[i] & 0xFF;
            String hv = Integer.toHexString(v);

            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
            stringBuilder.append(" ");
        }
        return stringBuilder.toString();
    }
    /**
     * byte数组转换成16进制字符串
     *
     * @param src
     * @param length 限制转换的长度, -1不限制
     * @return
     */
    public static String bytesToHexString(byte[] src, int length) {
        StringBuilder stringBuilder = new StringBuilder();
        StringBuilder stringBuilderEnd = new StringBuilder();
        if (src == null || src.length <= 0) {
            return null;
        }
        int maxLength = length <= 0 ? src.length : Math.min(length, src.length);
        for (int i = 0; i < maxLength; i++) {
            int v = src[i] & 0xFF;
            String hv = Integer.toHexString(v);

            if (hv.length() < 2) {
                stringBuilder.append(0);
            }
            stringBuilder.append(hv);
            stringBuilder.append(" ");
        }

        if(src.length > maxLength + 2){
            int secondLastByte = src[src.length - 2] & 0xFF;
            String secondLast = Integer.toHexString(secondLastByte);
            if (secondLast.length() < 2) {
                stringBuilderEnd.append(0);
            }
            stringBuilderEnd.append(secondLast.toUpperCase()).append(" ");

            int lastByte = src[src.length - 1] & 0xFF;
            String last = Integer.toHexString(lastByte);
            if (last.length() < 2) {
                stringBuilderEnd.append(0);
            }
            stringBuilderEnd.append(last.toUpperCase());

            stringBuilderEnd.append("  size = ").append(src.length);
        }
        return stringBuilder.toString().toUpperCase()+(src.length > maxLength ? "..." + stringBuilderEnd : "" );
    }

    /**
     * byte数组转换成16进制字符数组
     * 
     * @param src
     * @return
     */
    public static String[] bytesToHexStrings(byte[] src) {
        if (src == null || src.length <= 0) {
            return null;
        }
        String[] str = new String[src.length];

        for (int i = 0; i < src.length; i++) {
            int v = src[i] & 0xFF;
            String hv = Integer.toHexString(v);
            if (hv.length() == 1) {
                hv = 0 + hv;
            }
            str[i] = hv;

        }

        return str;
    }

    /**
     * 反转数组
     * 
     */
    @SuppressWarnings("unchecked")
    public static <T> T invertArray(T array) {
        int len = Array.getLength(array);

        Class<?> classz = array.getClass().getComponentType();

        Object dest = Array.newInstance(classz, len);

        System.arraycopy(array, 0, dest, 0, len);

        Object temp;

        for (int i = 0; i < (len / 2); i++) {
            temp = Array.get(dest, i);
            Array.set(dest, i, Array.get(dest, len - i - 1));
            Array.set(dest, len - i - 1, temp);
        }

        return (T) dest;
    }

    /***
     * 从byte[]的index开始，长为len，反序之后转换成int
     * 
     * @param from
     * @param index
     *            0...size-1
     * @param len
     * @return
     */
    public static int toRevInt(byte[] from, int index, int len) {
        int to = 0;
        int min = index + len - 1;
        for (int i = 0, i_from = min; i < len; i++, i_from--) {
            to = to << 8 | (from[i_from] & 0xff);
        }
        return to;
    }

    public static byte[] Int2Bit8(int num) {
        byte b = (byte) num;
        byte[] array = new byte[8];
        for (int i = 0; i <= 7; i++) {
            array[i] = (byte) (b & 1);
            b = (byte) (b >> 1);
        }

        return array;
    }

    public static int Bit8Array2Int(byte[] from) {
        int len = from.length;

        int i = 0;
        for (int j = len - 1; j >= 0; j--) {
            i += (from[j] << (len - 1 - j));
        }

        return i;
    }
    
    public static byte i2b(int in) {
		return (byte) Integer.toHexString(in).charAt(0);
	}

	/**
	 * 合并两个byte数组
	 * @param byte_1
	 * @param byte_2
	 * @return
	 */
	public static byte[] byteMerger(byte[] byte_1, byte[] byte_2) {
		byte[] byte_3 = new byte[byte_1.length + byte_2.length];
		System.arraycopy(byte_1, 0, byte_3, 0, byte_1.length);
		System.arraycopy(byte_2, 0, byte_3, byte_1.length, byte_2.length);
		return byte_3;
	}

	public static byte[] stringToByte(String str){
	    return StringToByte(str, CHAR_ENCODE);
    }
	public static byte[] StringToByte(String str, String charEncode) {
		byte[] destObj = null;
		try {
			if (null == str || str.trim().equals("")) {
				destObj = new byte[0];
				return destObj;
			} else {
				destObj = str.getBytes(charEncode);
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return destObj;
	}
	
	public static String bytetoString(byte[] b){
		String str = "";
		try {
			str= new String(b,CHAR_ENCODE);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return str;
	}
	
	public static byte[] getJsonByte(String json) {
		return StringToByte(json, CHAR_ENCODE);
	}

    /**
     * 获得指定文件的byte数组
     */
    public static byte[] getBytesByFilePath(String filePath){
        byte[] buffer = null;
        try {
            File file = new File(filePath);
            FileInputStream fis = new FileInputStream(file);
            ByteArrayOutputStream bos = new ByteArrayOutputStream((int) file.length());
            Log.d("FILE_TRANSFER", "ByteArrayOutputStream   =  file.length()" + file.length() +"----bos.length:"+bos.size());
            byte[] b = new byte[1000];
            int n;
            while ((n = fis.read(b)) != -1) {
                bos.write(b, 0, n);
            }
            fis.close();
            bos.close();
            buffer = bos.toByteArray();
        } catch (FileNotFoundException e) {
            Log.d("FILE_TRANSFER", "getBytesByFilePath FileNotFoundException = " + e);
            e.printStackTrace();
        } catch (IOException e) {
            Log.d("FILE_TRANSFER", "getBytesByFilePath IOException = " + e);
            e.printStackTrace();
        }
        return buffer;
    }

    public static boolean isEqualByteArrays(byte[] array1, byte[] array2) {
        if (array1.length != array2.length) {
            return false;
        }
        for (int i = 0; i < array1.length; i++) {
            if (array1[i] != array2[i]) {
                return false;
            }
        }
        return true;
    }

    /**
     * 是否是长包数据 33 ad da ad da ,大小端0xADDAADDA
     * @param data
     * @return
     */
    public static boolean isLongPacket(byte[] data){
        if(data==null || data.length<=11){
            return false;
        }
        if((data[0]&0xff)==0x33 && (data[1]&0xff)== 0xda
                && (data[2]&0xff)== 0xad&& (data[3]&0xff)== 0xda &&
                (data[4]&0xff)== 0xad && (data[5]&0xff)==0x01){//长包
           if((data[8]&0xff)==0x0b ||(data[8]&0xff)==0x60 || (data[8]&0xff)==0x65 || (data[8]&0xff)==0x70 ||(data[8]&0xff)==0x71 ||(data[8]&0xff)==0x72){//消息提醒,0x65 睡眠计划
              // 0x70 跑步计划
              // 0x71 跑步计划ble通知app
             //  0x72 跑步计划app通知ble
               return true;
           }
            if((data[8]&0xff)==0x08 && (data[12]&0xff)==0x02){
                Log.d("isLongPacket","filter delete dial cmd");
                // 删除表盘指令，部分手机发送慢，导致触发重发#246959
                return true;
            }
            return false;
        }
        return false;
    }

    public static byte[] hexStringToByteArray(String hex) {
        int len = hex.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4)
                    + Character.digit(hex.charAt(i+1), 16));
        }
        return data;
    }
}
