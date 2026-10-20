package com.idosmart.native_channel.actions.labelparsing;

import android.text.TextUtils;

import com.google.gson.Gson;


import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;

public class ActVersion {
    private String TAG = "ActVersion";

    private static final String VERSION_CODE = "version_code";
    private static final String BOARD_NAME = "board_name";

    private static ActVersion mAct;

    public static ActVersion getInstance() {
        if (mAct == null) {
            synchronized (ActVersion.class) {
                if (mAct == null) {
                    mAct = new ActVersion();
                }
            }
        }
        return mAct;
    }

    private VersionMsg getVersionMsg(String data) {
        String versionCode = LabelUtils.getLabelData(data, VERSION_CODE);
        String boardName = LabelUtils.getLabelData(data, BOARD_NAME);
        if (TextUtils.equals(versionCode, LabelUtils.ERROR_CODE) || TextUtils.equals(boardName, LabelUtils.ERROR_CODE)) {
            return null;
        }
        VersionMsg msg = new VersionMsg();
        msg.versionCode = versionCode;
        msg.boardName = boardName;

        return msg;
    }

    public String getVersion(String path) throws IOException {
        File file = new File(path);
        if (!file.exists()) {
            return "LabelUtils.ERROR_CODE";
        }

        RandomAccessFile file2 = new RandomAccessFile(path, "r");
        file2.seek(0x20);
        byte[] buffer = new byte[24];
        file2.read(buffer, 0, 24);

        byte[] binOff = new byte[4];
        for (int i = 0; i < 4; i++) {
            binOff[i] = buffer[16 + i];
        }
        long binOffL = Util.byteToLong(binOff);

        byte[] xmlSize = new byte[4];
        for (int i = 0; i < 4;i ++) {
            xmlSize[i] = buffer[20 + i];
        }
        long xmlSizeL = Util.byteToLong(xmlSize);

        RandomAccessFile file3 = new RandomAccessFile(path, "r");
        file3.seek(binOffL);
        buffer = new byte[(int) xmlSizeL];
        file3.read(buffer, 0, (int) xmlSizeL);
        String xmlData = new String(buffer);

        VersionMsg msg = getVersionMsg(xmlData);
        return msg.versionCode;
    }

    public String getBinMsg(String path) throws IOException {
        File f = new File(path);
        if (!f.exists()) {
            return "LabelUtils.ERROR_CODE";
        }
        RandomAccessFile file = new RandomAccessFile(path, "r");
        byte[] buffer = new byte[24];
        file.read(buffer, 0, 24);
        byte[] head = new byte[8];
        for (int i = 0; i < 8; i++) {
            head[i] = buffer[i];
        }
        String headS = new String(head);

        byte[] binSize = new byte[4];
        for (int i = 0; i < 4; i++) {
            binSize[i] = buffer[i + 20];
        }
        long binSizeL = Util.byteToLong(binSize);

        RandomAccessFile file2 = new RandomAccessFile(path, "r");
        file2.seek(0x20);
        buffer = new byte[24];
        file2.read(buffer, 0, 24);

        byte[] binOff = new byte[4];
        for (int i = 0; i < 4; i++) {
            binOff[i] = buffer[16 + i];
        }
        long binOffL = Util.byteToLong(binOff);

        byte[] xmlSize = new byte[4];
        for (int i = 0; i < 4;i ++) {
            xmlSize[i] = buffer[20 + i];
        }
        long xmlSizeL = Util.byteToLong(xmlSize);

        RandomAccessFile file3 = new RandomAccessFile(path, "r");
        file3.seek(binOffL);
        buffer = new byte[(int) xmlSizeL];
        file3.read(buffer, 0, (int) xmlSizeL);
        String xmlData = new String(buffer);

        VersionMsg msg = getVersionMsg(xmlData);

        if (msg == null) {
            return LabelUtils.ERROR_CODE;
        }

        String res = getBinJson(headS, binSizeL, xmlSizeL, msg);
        return res;
    }

    private String getBinJson(String head, long binSize, long xmlSize, VersionMsg msg) {

        BinJson bin = new BinJson(head, binSize, xmlSize, msg.versionCode, msg.boardName);

        Gson gson = new Gson();
        String json = gson.toJson(bin);

        return json;
    }

}
