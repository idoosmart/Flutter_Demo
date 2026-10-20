package com.idosmart.native_channel.actions.bean;

import java.util.List;

public class DialGroupBean {

    private String group;

    private List<DialBean> dialList;

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    public List<DialBean> getDialList() {
        return dialList;
    }

    public void setDialList(List<DialBean> dialList) {
        this.dialList = dialList;
    }
}
