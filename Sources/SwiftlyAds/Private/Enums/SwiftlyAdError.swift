//
//  SwiftlyAdError.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 04/08/25.
//

import Foundation

enum SwiftlyAdError: Error {
    case interStrialAdUnitIdNotSet
    case appOpenAdUnitIdNotSet
    case rewardedAdUnitIdNotSet
    case rewardedInterAdUnitIdNotSet
    case nativeAdUnitIdNotSet
    case interstitialAdNotLoaded
    case appOpenAdNotLoaded
    case rewardedAdNotLoaded
    case rewardedInterAdNotLoaded
    case consentManagerNotAvailable
    case consentNotObtained
}

extension SwiftlyAdError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .interStrialAdUnitIdNotSet: "Interstitial ad unit ID is not set."
        case .appOpenAdUnitIdNotSet: "AppOpen ad unit ID is not set."
        case .rewardedAdUnitIdNotSet: "Rewarded ad unit ID is not set."
        case .rewardedInterAdUnitIdNotSet: "RewardedInterstitial ad unit ID is not set."
        case .nativeAdUnitIdNotSet: "Native ad unit ID is not set."
        case .interstitialAdNotLoaded: "InterstitialAd Not Loaded."
        case .appOpenAdNotLoaded: "AppOpenAd Not Loaded."
        case .rewardedAdNotLoaded: "RewardedAd Not Loaded."
        case .rewardedInterAdNotLoaded: "RewardedInterstitialAd Not Loaded"
        case .consentManagerNotAvailable: "ConsentManager Not Available."
        case .consentNotObtained: "Consent Not Obtained."
        }
    }
}
