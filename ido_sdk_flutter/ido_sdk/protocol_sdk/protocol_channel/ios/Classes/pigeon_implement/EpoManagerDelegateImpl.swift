//
//  EpoManagerDelegate.swift
//  protocol_channel
//
//  Created by hc on 2024/8/8.
//

import Foundation

class EpoManagerDelegateImpl: ApiEpoManagerDelegate {
    static let shared = EpoManagerDelegateImpl()
    private init() {}
    
    weak var delegateGps: IDOEpoManagerDelegate?
    private(set) var upgradeStatus: IDOEpoUpgradeStatus = .idle
    
    var callbackUpgradeStatus: ((IDOEpoUpgradeStatus) -> Void)?
    var callbackDownProgress: ((Float) -> Void)?
    var callbackSendProgress: ((Float) -> Void)?
    var callbackComplete: ((Int) -> Void)?
    
    func onEpoStatusChanged(status: ApiEpoUpgradeStatus) throws {
        upgradeStatus = IDOEpoUpgradeStatus(rawValue: status.rawValue)!
        callbackUpgradeStatus?(upgradeStatus)
    }
    
    func onEpoDownloadProgress(progress: Double) throws {
        callbackDownProgress?(Float(progress))
    }
    
    func onEpoSendProgress(progress: Double) throws {
        callbackSendProgress?(Float(progress))
    }
    
    func onEpoComplete(errorCode: Int64) throws {
        callbackComplete?(errorCode.int)
    }
    
    func onGetGps(completion: @escaping (Result<ApiOTAGpsInfo?, any Error>) -> Void) {
        guard let gpsInfo = delegateGps?.getAppGpsInfo() else {
            completion(.success(nil))
            return
        }
        let rs = ApiOTAGpsInfo(tcxoOffset: 0,
                               longitude: Double(gpsInfo.longitude),
                               latitude: Double(gpsInfo.latitude),
                               altitude: Double(gpsInfo.altitude))
        completion(.success(rs))
    }
    
    
}
