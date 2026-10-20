package com.idosmart.native_channel.actions.labelparsing;

public class Util {

    public static long byteToLong(byte[] data) {
        long l64;
        l64=0l;
        l64 =  (long)data[0]&0xff;
        l64 |= (long)(data[1]&0xff)<<8;
        l64 |= (long)(data[2]&0xff)<<16;
        l64 |= (long)(data[3]&0xff)<<24;
//        l64 |= (long)(data[4]&0xff)<<32;
//        l64 |= (long)(data[5]&0xff)<<40;
//        l64 |= (long)(data[6]&0xff)<<48;
//        l64 |= (long)(data[7]&0xff)<<56;
        return l64;
    }
}
