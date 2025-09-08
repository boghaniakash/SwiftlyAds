//
//  SwiftlyAdsConfiguration.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 04/08/25.
//

public class SwiftlyAdsConfiguration {
    fileprivate var bannerAdUnitId: String?
    fileprivate var interstitialAdUnitId: String?
    fileprivate var rewardedAdUnitId: String?
    fileprivate var rewardedInterstitialAdUnitId: String?
    fileprivate var appOpenAdUnitId: String?
    fileprivate var nativeAdUnitId: String?
    fileprivate var isTaggedForChildDirectedTreatment: Bool?
    fileprivate var isTaggedForUnderAgeOfConsent: Bool?
    fileprivate var isPreLoadAds: Bool?
    fileprivate var mediationConfigurator: SwiftlyAdsMediationConfigurator?
    fileprivate var testDeviceIdentifiers: [String]?
    fileprivate var geography: SwiftlyDebugGeography?
    fileprivate var resetsConsentOnLaunch: Bool?
    fileprivate var interAdShowCount: Int?
    fileprivate var appOpenAdShowCount: Int?
    fileprivate var nativeAdShowCount: Int?
    fileprivate var environment: SwiftlyAdEnvironment?
    fileprivate var adRequest: SwiftlyAdRequest?
    
    public init() {}
}

public extension SwiftlyAdsConfiguration {
    @discardableResult
    func bannerAdUnitId(_ bannerAdUnitId: String?) -> SwiftlyAdsConfiguration {
        self.bannerAdUnitId = bannerAdUnitId
        return self
    }
    @discardableResult
    func interstitialAdUnitId(_ interstitialAdUnitId: String?) -> SwiftlyAdsConfiguration {
        self.interstitialAdUnitId = interstitialAdUnitId
        return self
    }
    @discardableResult
    func rewardedAdUnitId(_ rewardedAdUnitId: String?) -> SwiftlyAdsConfiguration {
        self.rewardedAdUnitId = rewardedAdUnitId
        return self
    }
    @discardableResult
    func rewardedInterstitialAdUnitId(_ rewardedInterstitialAdUnitId: String?) -> SwiftlyAdsConfiguration {
        self.rewardedInterstitialAdUnitId = rewardedInterstitialAdUnitId
        return self
    }
    @discardableResult
    func appOpenAdUnitId(_ appOpenAdUnitId: String?) -> SwiftlyAdsConfiguration {
        self.appOpenAdUnitId = appOpenAdUnitId
        return self
    }
    @discardableResult
    func nativeAdUnitId(_ nativeAdUnitId: String?) -> SwiftlyAdsConfiguration {
        self.nativeAdUnitId = nativeAdUnitId
        return self
    }
    @discardableResult
    func isTaggedForChildDirectedTreatment(_ bool: Bool?) -> SwiftlyAdsConfiguration {
        self.isTaggedForChildDirectedTreatment = bool
        return self
    }
    @discardableResult
    func isTaggedForUnderAgeOfConsent(_ bool: Bool?) -> SwiftlyAdsConfiguration {
        self.isTaggedForUnderAgeOfConsent = bool
        return self
    }
    @discardableResult
    func isPreLoadAds(_ bool: Bool) -> SwiftlyAdsConfiguration {
        self.isPreLoadAds = bool
        return self
    }
    @discardableResult
    func mediationConfigurator(_ configurator: SwiftlyAdsMediationConfigurator?) -> SwiftlyAdsConfiguration {
        self.mediationConfigurator = configurator
        return self
    }
    @discardableResult
    func testDeviceIdentifiers(_ ids: [String]) -> SwiftlyAdsConfiguration {
        self.testDeviceIdentifiers = ids
        return self
    }
    @discardableResult
    func geography(_ geography: SwiftlyDebugGeography) -> SwiftlyAdsConfiguration {
        self.geography = geography
        return self
    }
    @discardableResult
    func resetsConsentOnLaunch(_ bool: Bool) -> SwiftlyAdsConfiguration {
        self.resetsConsentOnLaunch = bool
        return self
    }
    @discardableResult
    func interAdShowCount(_ count: Int) -> SwiftlyAdsConfiguration {
        self.interAdShowCount = count
        return self
    }
    @discardableResult
    func appOpenAdShowCount(_ count: Int) -> SwiftlyAdsConfiguration {
        self.appOpenAdShowCount = count
        return self
    }
    @discardableResult
    func nativeAdShowCount(_ count: Int) -> SwiftlyAdsConfiguration {
        self.nativeAdShowCount = count
        return self
    }
    @discardableResult
    func setEnvironment(_ env: SwiftlyAdEnvironment) -> SwiftlyAdsConfiguration {
        self.environment = env
        return self
    }
    @discardableResult
    func adRequest(_ request: SwiftlyAdRequest) -> SwiftlyAdsConfiguration {
        self.adRequest = request
        return self
    }
}

extension SwiftlyAdsConfiguration {
    func build() -> SwiftlyAdsConfigurationProvider {
        SwiftlyAdsConfigurationProvider(
            bannerAdUnitId: bannerAdUnitId,
            interstitialAdUnitId: interstitialAdUnitId,
            rewardedAdUnitId: rewardedAdUnitId,
            rewardedInterstitialAdUnitId: rewardedInterstitialAdUnitId,
            appOpenAdUnitId: appOpenAdUnitId,
            nativeAdUnitId: nativeAdUnitId,
            isTaggedForChildDirectedTreatment: isTaggedForChildDirectedTreatment,
            isTaggedForUnderAgeOfConsent: isTaggedForUnderAgeOfConsent,
            isPreLoadAds: isPreLoadAds ?? false,
            mediationConfigurator: mediationConfigurator,
            testDeviceIdentifiers: testDeviceIdentifiers ?? [],
            geography: geography ?? .EEA,
            resetsConsentOnLaunch: resetsConsentOnLaunch ?? false,
            interAdShowCount: interAdShowCount ?? 1,
            appOpenAdShowCount: appOpenAdShowCount ?? 1,
            nativeAdShowCount: nativeAdShowCount ?? 1,
            environment: environment ?? .development,
            adRequest: adRequest ?? SwiftlyAdRequest()
        )
    }
}
