package com.example.flutter_bluetooth.utils;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Array;

public class ByteDataConvertUtil {
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
        return stringBuilder.toString().toUpperCase()+(src.length > maxLength ? "" : "...");
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
            byte[] b = new byte[1000];
            int n;
            while ((n = fis.read(b)) != -1) {
                bos.write(b, 0, n);
            }
            fis.close();
            bos.close();
            buffer = bos.toByteArray();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return buffer;
    }
}
