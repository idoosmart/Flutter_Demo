package com.idosmart.protocol_sdk

import com.idosmart.enums.*

interface IDOAlexaDelegate {
    /**
     * 获取健康数据
     * @param valueType 健康数据类型
     * @return 对应健康数据
     */
    fun getHealthValue(valueType: IDOGetValueType): Int

    /**
     * 获取心率数据
     * @param dataType 0: 平均，1： 最大，2： 最小
     * @param timeType 0：今天，1：上周，2：上个月，3：上一年
     * @return 心率
     */
    fun getHrValue(dataType: Int, timeType: Int): Int

    /**
     * 功能控制
     *
     * funType 0 关闭找手机功能
     */
    fun functionControl(funType: Int)
}

interface  IDOAlexaAuthDelegate {

    /**
     * Alexa认证需要打开的url和userCode
     * @param userCode
     * @param verificationUri
     */
    fun callbackPairCode(userCode: String, verificationUri: String)

    /**
    * 监听登录状态
    *
    * @param state 0 登录中 1 已登录 2 未登录
     */
    fun loginStateChanged(state: IDOAlexaLoginState)
}

interface AlexaInterface {

    /**
     * 是否已登录
     */
    val isLogin: Boolean

    /**
     * 监听登录状态变更
     */
    fun onLoginStateChanged(handle : (IDOAlexaLoginState) -> Unit)

    /**
    * 网络变更需实时调用此方法
    */
    fun onNetworkChanged(hasNetwork: Boolean)

    /**
     * 配置alexa
     * @param delegate 代理
     * @param clientId Alexa后台生成的ID
     */
    fun setupAlexa(delegate: IDOAlexaDelegate, clientId: String)


    /**
     * Alexa CBL授权
     * @param productId 在alexa后台注册的产品ID
     * @param handle 回调Alexa认证需要打开的verificationUri和pairCode
     * @param completion 授权结果
     * @return 可取消实例
     */
    fun authorizeRequest(productId: String,
    handle: (verificationUri: String,pairCode: String) -> Unit,
    completion: (rs: IDOAlexaAuthorizeResult) -> Unit): IDOCancellable

    /**
     * 退出登录
     */
    fun logout()
}