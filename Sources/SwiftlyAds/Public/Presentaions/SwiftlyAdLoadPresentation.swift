//
//  SwiftlyAdLoadPresentation.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 07/08/25.
//

import Foundation

public final class SwiftlyAdLoadPresentation: @unchecked Sendable {
    var onSuccess: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    @discardableResult
    public func onSuccess(_ handler: @escaping () -> Void) -> Self {
        onSuccess = handler
        return self
    }
    @discardableResult
    public func onError(_ handler: @escaping (Error) -> Void) -> Self {
        onError = handler
        return self
    }
}
