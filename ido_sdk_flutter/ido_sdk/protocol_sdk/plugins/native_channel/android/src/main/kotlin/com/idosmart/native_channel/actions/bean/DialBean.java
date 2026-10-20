package com.idosmart.native_channel.actions.bean;

public class DialBean {

    private String group;

    private String dialName;

    private String dialPicPath;

    private int id;

    private String dataPath;

    private boolean isCur = false;

    private boolean isDef = false;

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    public String getDialName() {
        return dialName;
    }

    public void setDialName(String dialName) {
        this.dialName = dialName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDataPath() {
        return dataPath;
    }

    public void setDataPath(String dataPath) {
        this.dataPath = dataPath;
    }

    public String getDialPicPath() {
        return dialPicPath;
    }

    public void setDialPicPath(String dialPicPath) {
        this.dialPicPath = dialPicPath;
    }

    public boolean isCur() {
        return isCur;
    }

    public void setCur(boolean cur) {
        isCur = cur;
    }

    public boolean isDef() {
        return isDef;
    }

    public void setDef(boolean def) {
        isDef = def;
    }
}
