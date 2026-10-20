package com.idosmart.native_channel.actions.labelparsing;

public class BinJson {
    String head_name;
    long bin_size;
    long xml_size;
    String version_code;
    String board_name;

    public BinJson(String head_name, long bin_size, long xml_size, String version_code, String board_name) {
        this.head_name = head_name;
        this.bin_size = bin_size;
        this.xml_size = xml_size;
        this.version_code = version_code;
        this.board_name = board_name;
    }

    public String getHead_name() {
        return head_name;
    }

    public void setHead_name(String head_name) {
        this.head_name = head_name;
    }

    public long getBin_size() {
        return bin_size;
    }

    public void setBin_size(long bin_size) {
        this.bin_size = bin_size;
    }

    public long getXml_size() {
        return xml_size;
    }

    public void setXml_size(long xml_size) {
        this.xml_size = xml_size;
    }

    public String getVersion_code() {
        return version_code;
    }

    public void setVersion_code(String version_code) {
        this.version_code = version_code;
    }

    public String getBoard_name() {
        return board_name;
    }

    public void setBoard_name(String board_name) {
        this.board_name = board_name;
    }
}
