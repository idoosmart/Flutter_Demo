package com.idosmart.native_channel.actions.labelparsing;


import android.text.TextUtils;

public class LabelUtils {
    private String TAG = "LabelUtils";

    public static final String ERROR_CODE = "-1";

    public static String getLabelData(String originalData, String targetData) {
        String sBegin = "<" + targetData + ">";
        String sEnd = "</" + targetData + ">";

        originalData = eliminate(originalData);

        int iBegin = TextUtils.indexOf(originalData, sBegin);
        int iEnd = TextUtils.indexOf(originalData, sEnd);

        if (iBegin == -1 || iEnd == -1) {
            return ERROR_CODE;
        }

        String res = TextUtils.substring(originalData, iBegin + sBegin.length(), iEnd);
        return res;
    }

    private static String eliminate(String data) {
        String cleanT = data.replaceAll("\t", "");
        String cleanN = cleanT.replaceAll("\n", "");
        return cleanN;
    }


}
