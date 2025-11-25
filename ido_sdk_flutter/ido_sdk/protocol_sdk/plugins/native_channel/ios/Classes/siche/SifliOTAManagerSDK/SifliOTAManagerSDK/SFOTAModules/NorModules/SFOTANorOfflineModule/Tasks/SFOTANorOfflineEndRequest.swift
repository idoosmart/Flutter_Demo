//
//  SFOTANorOfflineEndRequest.swift
//  SifliOTAManagerSDK
//
//  Created by Sean on 2024/12/24.
//

import UIKit

class SFOTANorOfflineEndRequest: OTANorV2TaskBase {
    let completion:NorV2ResultCompletion
    init(completion: @escaping NorV2ResultCompletion) {
        self.completion = completion
        super.init(messageType: .DFU_IMAGE_OFFLINE_END_REQ)
        
        
        self.baseCompletion = {[weak self] (tsk, msg, error) in
            guard let s = self else {
                return
            }
            if let err = error {
                s.completion(s,-1,err)
                return
            }
            
            let payload = msg!.payloadData
            if payload.count < 2{
                LogInsufficientMsgBytes(taskDes: s.name(), expect: 2, actual: payload.count)
                let err = SFOTAError.InsufficientBytes(expectCount: 2, actualCount: payload.count)
                s.completion(s, -1, err)
                return
            }
            
            let pd = NSData.init(data: payload)
            var result:UInt16 = 0
            pd.getBytes(&result, range: NSRange.init(location: 0, length: 2))
            
            s.completion(s,Int(result),nil);
        }
        
    }
    override func name() -> String {
        return "SFOTANorOfflineEndRequest"
    }
    override func marshalMsgPayloadData() -> Data {
        var reserved:UInt16 = 0
        let vData = Data.init(bytes: &reserved, count: 2)
        return vData
    }
}
