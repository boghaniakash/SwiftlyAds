//
//  SwiftlyNativeAd.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 12/08/25.
//

public final class SwiftlyNativeAd: @unchecked Sendable {
    var onReciveAd: ((SwiftlyNativeAds?) -> Void)?
    var onAdLoaded: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    @discardableResult
    public func onReciveAd(_ handler: @escaping (SwiftlyNativeAds?) -> Void) -> Self {
        onReciveAd = handler
        return self
    }
    @discardableResult
    public func onAdLoaded(_ handler: @escaping () -> Void) -> Self {
        onAdLoaded = handler
        return self
    }
    @discardableResult
    public func onError(_ handler: @escaping (Error) -> Void) -> Self {
        onError = handler
        return self
    }
}
