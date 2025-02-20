package com.idosmart.native_channel.siche.siche_interface

import com.idosmart.native_channel.pigeon_generate.api_sifli.OTAUpdateState


interface SicheToFlutterInterface {

    /**
     * 升级状态 | Upgrade status
     * state 状态值 | Status value
     * desc 状态值 | Status value
     */
    fun updateManageState(stateArg: OTAUpdateState, descArg: String)

    /**
     * 升级过程的进度 | Progress of the upgrade process
     * progress 进度 (0 ~ 1) | Progress (0 ~ 1)
     * message 升级日志信息 | Upgrade log information
     */
    fun updateManagerProgress(progressArg: Double)
    /**
     * 日志打印
     */
    fun log(logMsgArg:String)
}