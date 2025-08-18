//
//  SwiftyAdsMediationConfigurator.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 08/08/25.
//

import UserMessagingPlatform

public protocol SwiftlyAdsMediationConfigurator: Sendable {
    func updateCOPPA(isTaggedForChildDirectedTreatment: Bool)
    func updateGDPR(for consentStatus: ConsentStatus, isTaggedForUnderAgeOfConsent: Bool)
}
