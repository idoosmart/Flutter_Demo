//
//  AlexaImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/7/18.
//

import Foundation

private var _flagSetupAlexa = false
private var _alexa: Alexa? {
    return SwiftProtocolChannelPlugin.shared.alexa
}

class AlexaImpl: NSObject, IDOAlexaInterface {
    
    private var _handleBlock: ((String, String) -> Void)?
    private var _loginStateBlock: ((IDOAlexaLoginState) -> Void)?
    public private(set) var isLogin: Bool = false
    
    func onNetworkChanged(hasNetwork: Bool) {
        _runOnMainThread {
            _alexa?.onNetworkChanged(hasNetwork: hasNetwork, completion: { })
        }
    }
    
    func onLoginStateChanged(handle : @escaping (IDOAlexaLoginState) -> Void) {
        _loginStateBlock = handle
    }
    
    func setupAlexa(delegate: IDOAlexaDelegate, clientId: String) {
        AlexaDelegateImpl.shared.delegate = delegate
        AlexaAuthDelegateImpl.shared.delegate = self
        if (_flagSetupAlexa) {
            _runOnMainThread {
                _logNative("重复调用setupAlexa(...)")
            }
            return
        }
        _flagSetupAlexa = true
        _runOnMainThread {
            _alexa?.registerAlexa(clientId: clientId) {}
        }
    }
    
    func authorizeRequest(productId: String,
                          handle: @escaping (_ verificationUri: String, _ pairCode: String) -> Void,
                          completion: @escaping (_ rs: IDOAlexaAuthorizeResult) -> Void) -> IDOCancellable {
        _handleBlock = handle
        _runOnMainThread {
            _alexa?.authorizeRequest(productId: productId, completion: { rs in
                completion(IDOAlexaAuthorizeResult.init(rawValue: rs.int)!)
            })
        }
        return AlexaLoginCancellable()
    }

    func logout() {
        _runOnMainThread {
            _alexa?.logout {}
        }
    }
}

// MARK: -

class AlexaLoginCancellable: IDOCancellable {
    var isCancelled = false
    func cancel() {
        isCancelled = true
        _runOnMainThread {
            _alexa?.stopLogin {}
        }
    }
}

extension AlexaImpl: IDOAlexaAuthDelegate {
    func callbackPairCode(userCode: String, verificationUri: String) {
        _handleBlock?(verificationUri, userCode)
        _handleBlock = nil
    }
    
    func loginStateChanged(state: IDOAlexaLoginState) {
        switch(state) {
        case .logging:
            isLogin = false
        case .logined:
            isLogin = true
        case .logout:
            isLogin = false
        }
        _loginStateBlock?(state)
    }
    
}

/// alexa授权登录结果
@objc
public enum IDOAlexaAuthorizeResult: Int {
    /// 成功
    case successful = 0
    
    /// 失败
    case failure = 1
    
    /// 超时
    case timeout = 3
}
