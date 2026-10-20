package com.idosmart.native_channel.actions.ibluz.device.scan;

public abstract class BaseScanner {
    public boolean isScanning;

    public abstract void onStartScan();

    public abstract void onStopScan();

    public abstract void clean();

    public abstract void onScanFailed(ScanState scanState);
}
