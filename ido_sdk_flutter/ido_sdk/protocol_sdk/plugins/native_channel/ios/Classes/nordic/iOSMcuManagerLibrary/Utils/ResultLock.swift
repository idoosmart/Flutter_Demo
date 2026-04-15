/*
 * Copyright (c) 2017-2018 Runtime Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

import Foundation

internal typealias ResultLockKey = String

internal class ResultLock {
    
    private var semaphore: DispatchSemaphore
    
    internal var isOpen: Bool = false
    internal var error: Error?
    internal var key: ResultLockKey?
    
    internal init(isOpen: Bool) {
        self.isOpen = isOpen
        self.semaphore = DispatchSemaphore(value: 0)
    }
    
    /// Block the current thread until the condition is opened.
    ///
    /// If the condition is already opened, return immediately.
    internal func block() -> Result<Void, Error> {
        if !isOpen {
            semaphore.wait()
        }
        
        guard let error = error else { return .success(()) }
        return .failure(error)
    }
    
    /// Block the current thread until the condition is opened or until timeout.
    ///
    /// If the condition is opened, return immediately.
    internal func block(timeout: DispatchTime) -> Result<Void, Error> {
        let dispatchResult: DispatchTimeoutResult
        if !isOpen {
            dispatchResult = semaphore.wait(timeout: timeout)
        } else {
            dispatchResult = .success
        }
        
        if dispatchResult == .timedOut {
            return .failure(McuMgrTransportError.sendTimeout)
        } else if let error = error {
            return .failure(error)
        } else {
            return .success(())
        }
    }
    
    /// Open the condition, and release all threads that are blocked
    /// only if the provided key is the same that closed it, or if no key was used to close it.
    ///
    /// Any threads that later approach block() will not block unless close() is called.
    internal func open(key: ResultLockKey) {
        let canOpen = (self.key == nil) || (key == self.key)
        guard canOpen else { return }
        open()
    }
    
    /// Open the condition, and release all threads that are blocked.
    ///
    /// Any threads that later approach block() will not block unless close() is called.
    internal func open(_ error: Error? = nil) {
        objc_sync_enter(self)
        self.error = error
        if !isOpen {
            isOpen = true
            semaphore.signal()
        }
        key = nil
        objc_sync_exit(self)
    }
    
    /// Reset the condition to the closed state using the provided key.
    internal func close(key: ResultLockKey) {
        self.key = key
        close()
    }
    
    /// Reset the condition to the closed state.
    internal func close() {
        objc_sync_enter(self)
        error = nil
        semaphore = DispatchSemaphore(value: 0)
        isOpen = false
        objc_sync_exit(self)
    }
}
