//
//  GetFileInfoImpl.swift
//  app_info
//
//  Created by hedongyang on 2023/9/8.
//

import Foundation

class GetFileInfoImpl: ApiGetFileInfo {
    
    static let shared = GetFileInfoImpl()
    private init() {}
    
    func readFileInfo(path: String, completion: @escaping (Result<[AnyHashable : Any?]?, Error>) -> Void) {
        if FileManager.default.fileExists(atPath: path) {
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: path)
                let creationDate = attributes[.creationDate] as? Date
                let modificationDate = attributes[.modificationDate] as? Date
                let creationTimeStamp = creationDate?.timeIntervalSince1970 ?? 0
                let modificationTimeStamp = modificationDate?.timeIntervalSince1970 ?? 0
                completion(Result.success(["createSeconds":Int64(creationTimeStamp),
                                           "changeSeconds":Int64(modificationTimeStamp)]))
            } catch {
                print("Error: \(error)")
                completion(Result.success(["createSeconds":0,"changeSeconds":0]))
            }
        }else {
            completion(Result.success(["createSeconds":0,"changeSeconds":0]))
        }
    }
    
}
