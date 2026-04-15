package com.idosmart.native_channel.nordic.zephyr;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.os.Build;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.os.SystemClock;
import android.util.Log;
import android.util.Pair;

import androidx.annotation.MainThread;
import androidx.annotation.NonNull;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.Observer;


import com.idosmart.native_channel.common.utils.ByteDataConvertUtil;
import com.idosmart.native_channel.common.utils.ZipPackage;
import com.idosmart.native_channel.nordic.zephyr.observable.BondingState;
import com.idosmart.native_channel.nordic.zephyr.observable.ConnectionParameters;
import com.idosmart.native_channel.nordic.zephyr.observable.ConnectionState;
import com.idosmart.native_channel.nordic.zephyr.observable.ObservableMcuMgrBleTransport;
import com.idosmart.native_channel.siche.Config;

import org.jetbrains.annotations.Nullable;

import java.util.Collections;
import java.util.List;

import io.runtime.mcumgr.McuMgrTransport;
import io.runtime.mcumgr.ble.McuMgrBleTransport;
import io.runtime.mcumgr.dfu.FirmwareUpgradeCallback;
import io.runtime.mcumgr.dfu.FirmwareUpgradeController;
import io.runtime.mcumgr.dfu.FirmwareUpgradeManager;
import io.runtime.mcumgr.exception.McuMgrException;
import io.runtime.mcumgr.image.McuMgrImage;
import no.nordicsemi.android.ble.ConnectionPriorityRequest;

public class NordicZephyrDFUTask implements FirmwareUpgradeCallback {
    private static final String TAG = "IDO_BLE_DFU_NODIC_ZEPHYR";

    /**
     * Set estimated swap time, in milliseconds. This is an approximate time required by the McuBoot
     * to swap images after a successful upgrade.
     */
    private static final int ESTIMATED_SWAP_TIME = 10 * 1000;
    /**
     * Since version 1.1 the window upload is stable. It allows to send multiple packets concurrently,
     * without the need to wait for a notification. This may speed up the upload process significantly,
     * but it needs to be supported on the device side. See MCUMGR_BUF_COUNT in Zephyr KConfig file.
     */
    private static final int WINDOW_CAPACITY = 4;
    /**
     * The memory alignment is read when window upload capacity was set to 2+, otherwise is ignored.
     * For devices built on NCS 1.8 or older this may need to be set to 4 (4-byte alignment) on nRF5
     * devices. Each packet sent will be trimmed to have number of bytes dividable by given value.
     * Since NCS 1.9 the flash implementation can buffer unaligned data instead of discarding.
     */
    private static final int MEMORY_ALIGNMENT = 4;
    /**
     * Set a mode: Confirm only, Test only, Test & Confirm or None.
     * For multi-core update only the first one is supported. See details below.
     */
    private static final FirmwareUpgradeManager.Mode MODE = FirmwareUpgradeManager.Mode.CONFIRM_ONLY;

    public enum State {
        IDLE,
        VALIDATING,
        UPLOADING,
        PAUSED,
        TESTING,
        CONFIRMING,
        RESETTING,
        COMPLETE;

        public boolean inProgress() {
            return this != IDLE && this != COMPLETE;
        }

        public boolean canPauseOrResume() {
            return this == UPLOADING || this == PAUSED;
        }

        public boolean canCancel() {
            return this == VALIDATING || this == UPLOADING || this == PAUSED;
        }
    }

    public static class ThroughputData {
        public int progress;
        public float averageThroughput;

        public ThroughputData(final int progress, final float averageThroughput) {
            this.progress = progress;
            this.averageThroughput = averageThroughput;
        }

        @Override
        public String toString() {
            return "progress=" + progress + ", averageThroughput=" + averageThroughput;
        }
    }

    private ObservableMcuMgrBleTransport bleTransport;
    private FirmwareUpgradeManager manager;
    private Handler handler;
    private HandlerThread handlerThread;
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    private final MutableLiveData<State> stateLiveData = new MutableLiveData<>();
    private final MutableLiveData<ThroughputData> progressLiveData = new MutableLiveData<>();
    private final MutableLiveData<Boolean> advancedSettingsExpanded = new MutableLiveData<>();
    private final MutableLiveData<McuMgrException> errorLiveData = new MutableLiveData<>();
    private final SingleLiveEvent<Void> cancelledEvent = new SingleLiveEvent<>();
    private final MutableLiveData<Boolean> busyStateLiveData = new MutableLiveData<>();

    private long uploadStartTimestamp;
    private int imageSize, bytesSent, bytesSentSinceUploadStated, lastProgress;
    /**
     * A value indicating that the upload has not been started before.
     */
    private final static int NOT_STARTED = -1;
    /**
     * How often the throughput data should be sent to the graph.
     */
    private final static long REFRESH_RATE = 100L; /* ms */

    private final Observer<ConnectionState> connectionStateObserver = new Observer<ConnectionState>() {
        @Override
        public void onChanged(ConnectionState connectionState) {
            State state = getState().getValue();
            Log.d(TAG, "dfu connect state: " + connectionState + ", state = " + state);
            //设备断连或超时的情况：
            // 验证中断连：ota 失败
            // 传输中断连：ota 失败
            // 确认中断连：正常
            // 重置中断连：正常
            boolean failedState =
                    state != null && state != State.IDLE && state != State.CONFIRMING && state != State.RESETTING && state != State.COMPLETE;
            if (failedState && (connectionState == ConnectionState.TIMEOUT || connectionState == ConnectionState.DISCONNECTED || connectionState == ConnectionState.NOT_SUPPORTED)) {
                onUpgradeFailed(FirmwareUpgradeManager.State.NONE, new McuMgrException("dfu connect failed"));
            }
        }
    };
    private final Observer<BondingState> boundStateObserver = new Observer<BondingState>() {
        @Override
        public void onChanged(BondingState bondingState) {
            State state = getState().getValue();
            Log.d(TAG,"dfu bound state: " + bondingState + ", state = " + state);
            boolean failedState = state != State.IDLE && state != State.CONFIRMING && state != State.RESETTING && state != State.COMPLETE;
            if (failedState && bondingState == BondingState.NOT_BONDED) {
                onUpgradeFailed(FirmwareUpgradeManager.State.NONE, new McuMgrException("dfu bound failed"));
            }
        }
    };


    @MainThread
    protected NordicZephyrDFUTask(String macAddress) {
        BluetoothDevice device = BluetoothAdapter.getDefaultAdapter().getRemoteDevice(macAddress);
        handlerThread = new HandlerThread(TAG);
        handlerThread.start();
        this.handler = new Handler(handlerThread.getLooper()) {
            @Override
            public void handleMessage(@NonNull Message msg) {
                super.handleMessage(msg);
                Log.d(TAG, "handle message: " + msg.what);
            }
        };
        bleTransport = new ObservableMcuMgrBleTransport(Config.getApplication(), device, handler);
        bleTransport.setOnReleasedCallback(handlerThread::quitSafely);
        bleTransport.getState().observeForever(connectionStateObserver);
        bleTransport.getBondingState().observeForever(boundStateObserver);
        bleTransport.setLoggingEnabled(true);
        this.manager = new FirmwareUpgradeManager(bleTransport);
        this.manager.setFirmwareUpgradeCallback(this);


        stateLiveData.setValue(State.IDLE);
        progressLiveData.setValue(null);
        busyStateLiveData.setValue(false);
    }

    protected void onCleared() {
        if (manager != null) {
            manager.setFirmwareUpgradeCallback(null);
        }
        handlerThread.quitSafely();
        handler.removeCallbacksAndMessages(null);
        mainHandler.post(new Runnable() {
            @Override
            public void run() {
                bleTransport.getState().removeObserver(connectionStateObserver);
                bleTransport.getBondingState().removeObserver(boundStateObserver);
            }
        });
        progressLiveData.postValue(null);
        Log.d(TAG, "onCleared");
    }

    @NonNull
    public LiveData<Boolean> getAdvancedSettingsState() {
        return advancedSettingsExpanded;
    }

    public void setAdvancedSettingsExpanded(final boolean expanded) {
        advancedSettingsExpanded.setValue(expanded);
    }

    /**
     * Returns current transfer speed in KB/s.
     */
    @NonNull
    public LiveData<ThroughputData> getProgress() {
        return progressLiveData;
    }

    @NonNull
    public LiveData<State> getState() {
        return stateLiveData;
    }

    @Nullable
    public LiveData<ConnectionParameters> getConnectionParameters() {
        final McuMgrTransport transport = manager.getTransporter();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && transport instanceof ObservableMcuMgrBleTransport) {
            return ((ObservableMcuMgrBleTransport) transport).getConnectionParameters();
        }
        return null;
    }

    @NonNull
    public LiveData<McuMgrException> getError() {
        return errorLiveData;
    }

    @NonNull
    public LiveData<Void> getCancelledEvent() {
        return cancelledEvent;
    }

    public void upgrade(@NonNull final String filePath) {
        Log.d(TAG, "start upgrade, filePath = " + filePath);
        handler.post(() -> {
            try {
                byte[] fileByteData = ByteDataConvertUtil.getBytesByFilePath(filePath);
                if (fileByteData == null || fileByteData.length == 0) {
                    Log.d(TAG, "Invalid image file content: " + (fileByteData == null ? "null" : fileByteData.length));
                    upgradeFailed(new McuMgrException("Invalid image file content."));
                    return;
                }
                upgrade(fileByteData);
            } catch (Exception e) {
                upgradeFailed(new McuMgrException("Invalid image file content."));
            }
        });
    }

    public void upgrade(@NonNull final byte[] data) {
        List<Pair<Integer, byte[]>> images;
        try {
            // Check if the BIN file is valid.
            McuMgrImage.getHash(data);
            images = Collections.singletonList(new Pair<>(0, data));
        } catch (final Exception e) {
            try {
                final ZipPackage zip = new ZipPackage(data);
                images = zip.getBinaries();
            } catch (final Exception e1) {
                upgradeFailed(new McuMgrException("Invalid image file."));
                return;
            }
        }
        try {
            requestHighConnectionPriority();

            // Set the upgrade mode.
            manager.setMode(MODE);
            // rF52840, due to how the flash memory works, requires ~20 sec to erase images.
            manager.setEstimatedSwapTime(ESTIMATED_SWAP_TIME);
            // Set the window capacity. Values > 1 enable a new implementation for uploading
            // the images, which makes use of SMP pipelining feature.
            // The app will send this many packets immediately, without waiting for notification
            // confirming each packet. This value should be lower or equal to MCUMGR_BUF_COUNT
            // (https://github.com/zephyrproject-rtos/zephyr/blob/bd4ddec0c8c822bbdd420bd558b62c1d1a532c16/subsys/mgmt/mcumgr/Kconfig#L550)
            // parameter in KConfig in NCS / Zephyr configuration and should also be supported
            // on Mynewt devices.
            // Mind, that in Zephyr,  before https://github.com/zephyrproject-rtos/zephyr/pull/41959
            // was merged, the device required data to be sent with memory alignment. Otherwise,
            // the device would ignore uneven bytes and reply with lower than expected offset
            // causing multiple packets to be sent again dropping the speed instead of increasing it.
            manager.setWindowUploadCapacity(WINDOW_CAPACITY);
            // Set the selected memory alignment. In the app this defaults to 4 to match Nordic
            // devices, but can be modified in the UI.
            manager.setMemoryAlignment(MEMORY_ALIGNMENT);

            manager.start(images, false);
            Log.d(TAG, "dfu start");
        } catch (final McuMgrException e) {
            upgradeFailed(new McuMgrException("Invalid image file."));
        }
    }

    public void pause() {
        if (manager.isInProgress()) {
            handler.removeCallbacks(graphUpdater);
            stateLiveData.postValue(State.PAUSED);
            manager.pause();
            Log.d(TAG, "Upload paused");
            setLoggingEnabled(true);
            setReady();
        }
    }

    public void resume() {
        if (manager.isPaused()) {
            setBusy();
            stateLiveData.postValue(State.UPLOADING);
            Log.d(TAG, "Upload resumed");
            bytesSentSinceUploadStated = NOT_STARTED;
            setLoggingEnabled(false);
            manager.resume();
        }
    }

    public void cancel() {
        Log.d(TAG, "cancel");
        manager.cancel();
        onCleared();
    }

    @Override
    public void onUpgradeStarted(final FirmwareUpgradeController controller) {
        Log.d(TAG, "upgrade start");
        postBusy();
        progressLiveData.setValue(null);
        stateLiveData.setValue(State.VALIDATING);
    }

    @Override
    public void onStateChanged(
            final FirmwareUpgradeManager.State prevState,
            final FirmwareUpgradeManager.State newState) {
        setLoggingEnabled(newState != FirmwareUpgradeManager.State.UPLOAD);
        switch (newState) {
            case UPLOAD:
                Log.d(TAG, "Uploading firmware...");
                bytesSentSinceUploadStated = NOT_STARTED;
                stateLiveData.postValue(State.UPLOADING);
                break;
            case TEST:
                handler.removeCallbacks(graphUpdater);
                stateLiveData.postValue(State.TESTING);
                break;
            case CONFIRM:
                handler.removeCallbacks(graphUpdater);
                stateLiveData.postValue(State.CONFIRMING);
                break;
            case RESET:
                stateLiveData.postValue(State.RESETTING);
                break;
        }
    }

    private final Runnable graphUpdater = new Runnable() {
        @Override
        public void run() {
            if (manager.getState() != FirmwareUpgradeManager.State.UPLOAD || manager.isPaused()) {
                return;
            }

            final long timestamp = SystemClock.uptimeMillis();
            // Calculate the current upload progress.
            final int progress = (int) (bytesSent * 100.f /* % */ / imageSize);
            if (lastProgress != progress) {
                lastProgress = progress;

                // Calculate the average throughout.
                // This is done by diving number of bytes sent since upload has been started (or resumed)
                // by the time since that moment. The minimum time of MIN_INTERVAL ms prevents from
                // graph peaks that may happen when .
                final float bytesSentSinceUploadStarted = bytesSent - bytesSentSinceUploadStated;
                final float timeSinceUploadStarted = timestamp - uploadStartTimestamp;
                final float averageThroughput = bytesSentSinceUploadStarted / timeSinceUploadStarted; // bytes / ms = KB/s
                Log.d(TAG, "dfu progress: " + progress + ", averageThroughput = " + averageThroughput);
                progressLiveData.postValue(new ThroughputData(progress, averageThroughput));
            }

            if (manager.getState() == FirmwareUpgradeManager.State.UPLOAD && !manager.isPaused()) {
                handler.postAtTime(this, timestamp + REFRESH_RATE);
            }
        }
    };

    @Override
    public void onUploadProgressChanged(final int bytesSent, final int imageSize, final long timestamp) {
        this.imageSize = imageSize;
        this.bytesSent = bytesSent;

        final long uptimeMillis = SystemClock.uptimeMillis();

        // Check if this is the first time this method is called since:
        // - the start of an upload
        // - after resume
        if (bytesSentSinceUploadStated == NOT_STARTED) {
            lastProgress = NOT_STARTED;

            // If a new image started being sending, clear the progress graph.
            progressLiveData.postValue(null);

            // To calculate the throughput it is necessary to store the initial timestamp and
            // the number of bytes sent so far. Mind, that the upload may be resumed from any point,
            // not necessarily from the beginning.
            uploadStartTimestamp = uptimeMillis;
            bytesSentSinceUploadStated = bytesSent;

            // Begin updating the graph.
            handler.removeCallbacks(graphUpdater);
            handler.postAtTime(graphUpdater, uptimeMillis + REFRESH_RATE);
        }
        // When done, reset the counter.
        if (bytesSent == imageSize) {
            progressLiveData.postValue(new ThroughputData(100, 0));
            Log.d(TAG,
                    "Image (" + (imageSize - bytesSentSinceUploadStated) + " bytes) sent in " + (uptimeMillis - uploadStartTimestamp) +
                            " ms (avg speed: " + ((float) (imageSize - bytesSentSinceUploadStated) / (float) (uptimeMillis - uploadStartTimestamp)) + " kB/s)");
            // Finish the graph.
            graphUpdater.run();
            // Reset the initial bytes counter, so if there is a next image uploaded afterwards,
            // it will start the throughput calculations again.
            bytesSentSinceUploadStated = NOT_STARTED;
        }
    }

    @Override
    public void onUpgradeCompleted() {
        stateLiveData.postValue(State.COMPLETE);
        Log.d(TAG, "Upgrade complete");
        release();
    }

    @Override
    public void onUpgradeCanceled(final FirmwareUpgradeManager.State state) {
        handler.removeCallbacks(graphUpdater);
        progressLiveData.postValue(null);
        stateLiveData.postValue(State.IDLE);
        cancelledEvent.post();
        Log.d(TAG, "Upgrade cancelled");
        release();
    }

    @Override
    public void onUpgradeFailed(final FirmwareUpgradeManager.State state, final McuMgrException error) {
        upgradeFailed(error);
    }

    private void upgradeFailed(McuMgrException error) {
        handler.removeCallbacks(graphUpdater);
        errorLiveData.postValue(error);
        Log.d(TAG, "Upgrade failed:" + error);
        release();
    }

    private void release() {
        Log.d(TAG, "release");
        setLoggingEnabled(true);
        postReady();
        onCleared();
    }

    private void requestHighConnectionPriority() {
        final McuMgrTransport transporter = manager.getTransporter();
        if (transporter instanceof McuMgrBleTransport) {
            final McuMgrBleTransport bleTransporter = (McuMgrBleTransport) transporter;
            bleTransporter.requestConnPriority(ConnectionPriorityRequest.CONNECTION_PRIORITY_HIGH);
        }
    }

    private void setLoggingEnabled(final boolean enabled) {
        if (manager == null) return;
        final McuMgrTransport transporter = manager.getTransporter();
        if (transporter instanceof McuMgrBleTransport) {
            final McuMgrBleTransport bleTransporter = (McuMgrBleTransport) transporter;
//            bleTransporter.setLoggingEnabled(enabled);
        }
    }

    @NonNull
    public LiveData<Boolean> getBusyState() {
        return busyStateLiveData;
    }

    void setBusy() {
        busyStateLiveData.setValue(true);
    }

    void postBusy() {
        busyStateLiveData.postValue(true);
    }

    void setReady() {
        busyStateLiveData.setValue(false);
    }

    void postReady() {
        busyStateLiveData.postValue(false);
    }
}
