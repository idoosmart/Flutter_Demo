package com.example.flutter_bluetooth.dfu.rtk.auth;

public class RtkAuth {


    public static class AuthPara{
        public int deviceId;//从升级bin文件中获取的ID号
        public int version;//版本0 表示不进行版本校验,用于不能降级的约束,默认0
    }

    public static class AuthResult{
        /**
         * 0x0
         * 校验成功
         * 0x01
         * ID校验失败
         * 0x02
         * 版本号校验失败
         * 0x03
         * 电量不足
         * 0x04
         * 其他错误
         */
        public int errCode;
    }


}
