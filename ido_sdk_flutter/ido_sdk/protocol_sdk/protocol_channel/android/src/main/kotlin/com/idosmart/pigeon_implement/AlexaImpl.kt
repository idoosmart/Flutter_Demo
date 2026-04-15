package com.idosmart.pigeon_implement

import com.idosmart.pigeongen.api_alexa.*
import com.idosmart.protocol_channel.plugin
import com.idosmart.protocol_sdk.*
import com.idosmart.enums.*
import com.idosmart.protocol_channel.innerRunOnMainThread

class AlexaLoginCancellable(override var isCancelled: Boolean = false) : IDOCancellable {

    private fun alexa(): Alexa? {
        return plugin.alexa()
    }

    override fun cancel() {
        isCancelled = true
        alexa()?.stopLogin {}
    }

}

internal class AlexaImpl: AlexaInterface, IDOAlexaAuthDelegate {

    private var _handleBlock: ((String,String) -> Unit)? = null
    private var _loginStateBlock: ((IDOAlexaLoginState) -> Unit)? = null

    private fun alexa(): Alexa? {
        return plugin.alexa()
    }

    private var _isLogin = false

    override val isLogin: Boolean
        get() = _isLogin

    override fun onLoginStateChanged(handle: (IDOAlexaLoginState) -> Unit) {
        _loginStateBlock = handle
    }

    override fun onNetworkChanged(hasNetwork: Boolean) {
        innerRunOnMainThread {
            alexa()?.onNetworkChanged(hasNetwork) {}
        }
    }

    override fun setupAlexa(delegate: IDOAlexaDelegate, clientId: String) {
        AlexaDelegateImpl.instance().delegate = delegate
        AlexaAuthDelegateImpl.instance().delegate = this
        innerRunOnMainThread {
            alexa()?.registerAlexa(clientId) {}
        }
    }

    override fun authorizeRequest(
        productId: String,
        handle: (verificationUri: String, pairCode: String) -> Unit,
        completion: (rs: IDOAlexaAuthorizeResult) -> Unit
    ): IDOCancellable {
        _handleBlock = handle
        innerRunOnMainThread {
            alexa()?.authorizeRequest(productId) {
                completion(
                    IDOAlexaAuthorizeResult.ofRaw(it.toInt()) ?: IDOAlexaAuthorizeResult.SUCCESSFUL
                )
            }
        }
        return AlexaLoginCancellable()
    }

    override fun logout() {
        innerRunOnMainThread {
            alexa()?.logout {}
        }
    }

    override fun callbackPairCode(userCode: String, verificationUri: String) {
        _handleBlock?.let { it(verificationUri,userCode) }
    }

    override fun loginStateChanged(state: IDOAlexaLoginState) {
        val loginState = IDOAlexaLoginState.ofRaw(state.raw) ?: IDOAlexaLoginState.LOGGING
        when (loginState) {
            IDOAlexaLoginState.LOGGING -> _isLogin = false
            IDOAlexaLoginState.LOGINED -> _isLogin = true
            IDOAlexaLoginState.LOGOUT -> _isLogin = false
        }
        _loginStateBlock?.let { it(loginState) }
    }


}
