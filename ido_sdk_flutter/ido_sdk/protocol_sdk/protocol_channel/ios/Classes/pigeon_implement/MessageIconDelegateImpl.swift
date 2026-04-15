//
//  MessageIconDelegateImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/11/20.
//

import Foundation

class MessageIconDelegateImpl: MessageIconDelegate {
    
    static let shared = MessageIconDelegateImpl()
    private init() {}
    
    private(set) var updating : Bool = false
    private(set) var dirPath: String = ""
    
    func listenMessageIconState(updating: Bool) throws {
        self.updating = updating
    }
    
    func listenIconDirPath(path: String) throws {
        self.dirPath = path
    }
    
    
}
