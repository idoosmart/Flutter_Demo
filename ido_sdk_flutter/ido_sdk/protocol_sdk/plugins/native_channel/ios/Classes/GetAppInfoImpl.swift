//
//  GetAppInfoImpl.swift
//  app_info
//
//  Created by hedongyang on 2023/9/8.
//

import Foundation

class GetAppInfoImpl: ApiGetAppInfo {
    
    func readInstallAppInfoList(force: Bool, completion: @escaping (Result<[[AnyHashable : Any?]], Error>) -> Void) {
        
    }
    
    func readDefaultAppList(completion: @escaping (Result<[[AnyHashable : Any?]], Error>) -> Void) {
        
    }
    
    func readCurrentAppInfo(type: Int64, completion: @escaping (Result<[AnyHashable : Any?]?, Error>) -> Void) {
        
    }
    
    func convertEventType2PackageName(type: Int64, completion: @escaping (Result<String?, Error>) -> Void) {
        
    }
    
    func convertEventTypeByPackageName(name: String, completion: @escaping (Result<Int64, Error>) -> Void) {
        
    }
    
    func isDefaultApp(packageName: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
    
    static let shared = GetAppInfoImpl()
    private init() {}
    
}
