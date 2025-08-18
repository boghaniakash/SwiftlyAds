//
//  SwiftlyRewardInterAd.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 07/08/25.
//

import Foundation

public final class SwiftlyRewardInterAd: @unchecked Sendable {
    var onOpen: (() -> Void)?
    var onClose: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onReward: ((NSDecimalNumber) -> Void)?
    
    @discardableResult
    public func onOpen(_ handler: @escaping () -> Void) -> Self {
        onOpen = handler
        return self
    }
    @discardableResult
    public func onClose(_ handler: @escaping () -> Void) -> Self {
        onClose = handler
        return self
    }
    @discardableResult
    public func onError(_ handler: @escaping (Error) -> Void) -> Self {
        onError = handler
        return self
    }
    @discardableResult
    public func onReward(_ handler: @escaping (NSDecimalNumber) -> Void) -> Self {
        onReward = handler
        return self
    }
}
