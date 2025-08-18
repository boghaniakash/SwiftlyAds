//
//  SwiftlyAdsConfigurationProvider.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 04/08/25.
//

struct SwiftlyAdsConfigurationProvider: @unchecked Sendable {
    let bannerAdUnitId: String?
    let interstitialAdUnitId: String?
    let rewardedAdUnitId: String?
    let rewardedInterstitialAdUnitId: String?
    let appOpenAdUnitId: String?
    let nativeAdUnitId: String?
    let isTaggedForChildDirectedTreatment: Bool?
    let isTaggedForUnderAgeOfConsent: Bool?
    let mediationConfigurator: SwiftlyAdsMediationConfigurator?
    let testDeviceIdentifiers: [String]
    let geography: SwiftlyDebugGeography
    let resetsConsentOnLaunch: Bool
    let interAdShowCount: Int
    let appOpenAdShowCount: Int
    let nativeAdShowCount: Int
    let environment: SwiftlyAdEnvironment
    let adRequest: SwiftlyAdRequest
}
