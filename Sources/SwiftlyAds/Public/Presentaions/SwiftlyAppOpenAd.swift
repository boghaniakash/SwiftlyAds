//
//  SwiftlyAppOpenAd.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 07/08/25.
//

public final class SwiftlyAppOpenAd: @unchecked Sendable {
    var onOpen: (() -> Void)?
    var onClose: (() -> Void)?
    var onError: ((Error) -> Void)?
    
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
}
