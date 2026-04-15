//
//  BasicManager.swift
//  
//
//  Created by Dinesh Harjani on 21/9/21.
//

import Foundation

// MARK: - BasicManager

/// Sends commands belonging to the Basic Group.
///
internal class BasicManager: McuManager {
    override class var TAG: McuMgrLogCategory { .basic }
    
    // MARK: - Constants

    internal static let MAX_ECHO_MESSAGE_SIZE_BYTES = 2475
    
    enum ID: UInt8 {
        case reset = 0
    }
    
    // MARK: - Init
    
    internal init(transport: McuMgrTransport) {
        super.init(group: .basic, transport: transport)
    }
    
    // MARK: - Commands

    /// Erase stored Application-Level Settings from the Application Core.
    ///
    /// - parameter callback: The response callback with a ``McuMgrResponse``.
    internal func eraseAppSettings(callback: @escaping McuMgrCallback<McuMgrResponse>) {
        send(op: .write, commandId: ID.reset, payload: [:], timeout: McuManager.FAST_TIMEOUT, callback: callback)
    }
}

// MARK: - BasicManagerError

internal enum BasicManagerError: UInt64, Error, LocalizedError {
    case noError = 0
    case unknown = 1
    case flashOpenFailed = 2
    case flashConfigQueryFailed = 3
    case flashEraseFailed = 4
    
    internal var errorDescription: String? {
        switch self {
        case .noError:
            return "Success"
        case .unknown:
            return "Unknown error"
        case .flashOpenFailed:
            return "Opening flash area failed"
        case .flashConfigQueryFailed:
            return "Querying flash area parameters failed"
        case .flashEraseFailed:
            return "Erasing flash area failed"
        }
    }
}
