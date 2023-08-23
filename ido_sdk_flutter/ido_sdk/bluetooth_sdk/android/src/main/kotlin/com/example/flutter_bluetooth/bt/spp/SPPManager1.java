//package com.example.flutter_bluetooth.bt.spp;
//
//
///**
// * @author tianwei
// * @date 2022/12/16
// * @time 14:30
// * 用途:SPP管理类型
// */
//public class SPPManager1 {
//
//    /**
//     * 连接spp
//     *
//     * @param btMacAddress 设备的bt mac，设备的bt mac，设备的bt mac
//     * @param btMacAddress 设备的bt mac，设备的bt mac，设备的bt mac
//     * @param btMacAddress 设备的bt mac，设备的bt mac，设备的bt mac
//     * @param listener     连接回调
//     */
//    public static void connect(String btMacAddress, ISPPConnectStateListener listener) {
//        SPPConnectPresenter.getPresenter().connect(btMacAddress, listener);
//    }
//
//    /**
//     * SPP断连
//     */
//    public static void disconnect() {
//        SPPConnectPresenter.getPresenter().toDisconnect();
//    }
//
//    /**
//     * 判断SPP连接状态
//     *
//     * @return
//     */
//    public static boolean isConnected() {
//        return SPPConnectPresenter.getPresenter().isConnected();
//    }
//
//    /**
//     * 通过spp发送数据
//     *
//     * @param data
//     */
//    public static void writeData(byte[] data) {
//        SPPConnectPresenter.getPresenter().addCmd(data);
//    }
//}
