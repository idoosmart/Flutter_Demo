package com.example.flutter_bluetooth.bt;

/**
 * @author tianwei
 * @date 2022/10/8
 * @time 10:47
 * 用途: 配对回调
 */
public interface IBondStateListener {
    public static final int BOND_TIMEOUT = 1;
    public static final int BOND_NOT_FIND_DEVICE = 2;
    public static final int BOND_FAILED = 3;

    /**
     * @param code @see {@link IBondStateListener#BOND_TIMEOUT}
     *             ,{@link IBondStateListener#BOND_NOT_FIND_DEVICE}
     *             ,{@link IBondStateListener#BOND_FAILED}
     */
    void onBondFailed(String macAddress, int code, String msg);

    void onBonded(String macAddress);

}
