package com.idosmart.native_channel.actions.ibluz.util;


import android.util.Log;

/**
 * Created by InidHu on 2018/11/29.
 */

public class BitmapUtils {

    /* 计算0比特位的个数 */
    public static int countZeroBit(byte[] bitmap) {
        int count = 0;


        for (byte x : bitmap) {
            while ((x + 1) != 0) {
                x |= (x + 1);
                count++;
            }
        }

        return count;
    }

    public static int[] getZeroBitIndexMap(byte[] bitmap, int groupNum) {
        int num = countZeroBit(bitmap);
        Log.e("nick_getZero_num", num + "");
        num = groupNum;
        int[] array = new int[num];
        int count = 0;
        int index = 0;
        for (byte b : bitmap) {
            for (int i = 0; i < groupNum; i++) {
                int offset = (index % groupNum);

                if ((b & (0x1 << offset)) == 0x0) {
                    array[count] = index;

                    count++;
                }

                index++;
            }
        }

        return array;
    }
}
