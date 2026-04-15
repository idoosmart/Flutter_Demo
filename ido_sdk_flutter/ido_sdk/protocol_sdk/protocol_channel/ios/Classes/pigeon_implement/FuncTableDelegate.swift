//
//  FuncTableDelegate.swift
//  protocol_channel
//
//  Created by hc on 2023/7/24.
//

import Foundation

class FuncTableDelegateImpl: FuncTableDelegate {
    static let shared = FuncTableDelegateImpl()
    private init() {}
    
    private(set) var funcTableInfo: FunctionTableModel?
    
    var callbackFuncTable: ((IDOFuncTableInterface) -> Void)?
    
    /// C 层为 `support_pet_info`（snake），模型属性为 `supportPetInfo`；解码前写入 camelCase 键（兼容旧版 support_pet_info_02_03_0A）。
    private func normalizeFuncTableJson(_ funcTableJson: String) -> Data? {
        guard let data = funcTableJson.data(using: .utf8),
              var obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return funcTableJson.data(using: .utf8)
        }
        if obj["supportPetInfo"] == nil {
            if let v = obj["support_pet_info"] {
                obj["supportPetInfo"] = v
            } else if let v = obj["support_pet_info_02_03_0A"] {
                obj["supportPetInfo"] = v
            }
        }
        return try? JSONSerialization.data(withJSONObject: obj, options: [])
    }
    
    /// 功能表变更通知
    func listenFuncTableChanged(funcTableJson: String) {
        guard let jsonData = normalizeFuncTableJson(funcTableJson) else {
            funcTableInfo = nil
            return
        }
        print(funcTableJson)
        let obj = try! JSONDecoder().decode(FunctionTableModel.self, from: jsonData)
        funcTableInfo = obj
    }
    
    /// 绑定时获取的功能表通知(绑定专用)
    func listenFuncTableOnBind(funcTableJson: String) {
        guard let jsonData = normalizeFuncTableJson(funcTableJson) else {
            return
        }
        let obj = try! JSONDecoder().decode(FunctionTableModel.self, from: jsonData)
        callbackFuncTable?(FuncTableImpl(funcTableInfo: obj))
        callbackFuncTable = nil
    }
}
