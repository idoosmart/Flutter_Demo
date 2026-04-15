//
//  IDOAlexaInterface.swift
//  alexa_channel
//
//  Created by hc on 2023/11/2.
//

import Foundation

/// Alexa
@objc
public protocol IDOAlexaInterface {
    
    /// 网络变更需实时调用此方法
    func onNetworkChanged(hasNetwork: Bool)
    
    /// 配置alexa
    /// - Parameters:
    ///   - delegate : 代理
    ///   - clientId: Alexa后台生成的ID
    func setupAlexa(delegate: IDOAlexaDelegate, clientId: String)

    /// 是否已登录
    var isLogin: Bool { get }

    /// 监听登录状态变更
    func onLoginStateChanged(handle: @escaping (IDOAlexaLoginState) -> Void)


    /// Alexa CBL授权
    /// - Parameters:
    ///   - productId: 在alexa后台注册的产品ID
    ///   - handle: 回调Alexa认证需要打开的verificationUri和pairCode
    ///   - completion: 授权结果
    /// - Returns: 可取消实例
    @discardableResult
    func authorizeRequest(productId: String,
                          handle: @escaping (_ verificationUri: String, _ pairCode: String) -> Void,
                          completion: @escaping (_ rs: IDOAlexaAuthorizeResult) -> Void) -> IDOCancellable

    /// 退出登录
    func logout()
}
