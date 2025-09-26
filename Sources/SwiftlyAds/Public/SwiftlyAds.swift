//
//  SwiftlyAds.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 02/08/25.
//

import GoogleMobileAds
import UserMessagingPlatform
import SwiftUI

public typealias SwiftlyNativeAds = NativeAd
public typealias SwiftlyAdRequest = Request
public typealias SwiftlyDebugGeography = DebugGeography

public final class SwiftlyAds: NSObject, @unchecked Sendable {
    // MARK: - Public + Static
    public static let shared = SwiftlyAds()
    
    // MARK: - Private + Properties
    private let mobileAds: MobileAds
    
    private var configuration: SwiftlyAdsConfigurationProvider?
    private var interstitialAd: InterAdManager?
    private var appOpenAd: AppOpenAdManager?
    private var rewardAd: RewardAdManager?
    private var rewardInterAd: RewardInterAdManager?
    private var nativeAd: NativeAdManager?
    private var consentManager: AdsConsentManager?
    
    private var adLoadPresentation: SwiftlyAdLoadPresentation = SwiftlyAdLoadPresentation()
    private var swiftlyInterAd: SwiftlyInterAd = SwiftlyInterAd()
    private var swiftlyAppOpenAd: SwiftlyAppOpenAd = SwiftlyAppOpenAd()
    private var swiftlyRewardAd: SwiftlyRewardAd = SwiftlyRewardAd()
    private var swiftlyRewardInterAd: SwiftlyRewardInterAd = SwiftlyRewardInterAd()
    private var swiftlyNativeAd: SwiftlyNativeAd = SwiftlyNativeAd()
    private var disabled: Bool = false
    private var hasInitializedMobileAds = false
    private var interAdCounter: Int = 0
    private var appOpenAdCounter: Int = 0
    private var nativeAdCounter: Int = 0
    private var showConsent: Bool = false
    
    private var hasConsent: Bool {
        if showConsent {
            switch consentStatus {
            case .notRequired, .obtained:
                return true
            default:
                return false
            }
        } else {
            return true
        }
    }
    
    // MARK: - Initialization
    private override init() {
        mobileAds = .shared
        super.init()
    }
}

// MARK: - Public + Extentions
public extension SwiftlyAds {
    @discardableResult
    func initializeIfNeeded(from viewController: UIViewController, showConsent: Bool = true) async -> SwiftlyAdLoadPresentation {
        guard !hasInitializedMobileAds else {
            doWork(after: 0.1) { self.adLoadPresentation.onSuccess?() }
            return adLoadPresentation
        }
        do {
            self.showConsent = showConsent
            if showConsent, let consentManager { try await consentManager.request(from: viewController) }
            _ = await mobileAds.start()
            hasInitializedMobileAds = true
            if self.configuration?.isPreLoadAds ?? false { try await loadAds() }
            doWork(after: 0.1) { self.adLoadPresentation.onSuccess?() }
        } catch {
            doWork(after: 0.1) { self.adLoadPresentation.onError?(error) }
        }
        return adLoadPresentation
    }
    func configure(_ configuration: SwiftlyAdsConfiguration) {
        self.configuration = configuration.build()
        let request = self.configuration?.adRequest ?? SwiftlyAdRequest()
        if let interstitialAdUnitId = self.configuration?.interstitialAdUnitId {
            interstitialAd = InterAdManager(adUnitId: interstitialAdUnitId, adRequest: request, activePresentation: swiftlyInterAd)
        }
        if let appOpenAdUnitId = self.configuration?.appOpenAdUnitId {
            appOpenAd = AppOpenAdManager(adUnitId: appOpenAdUnitId, adRequest: request, activePresentation: swiftlyAppOpenAd)
        }
        if let rewardedAdUnitId = self.configuration?.rewardedAdUnitId {
            rewardAd = RewardAdManager(adUnitId: rewardedAdUnitId, adRequest: request, activePresentation: swiftlyRewardAd)
        }
        if let rewardedInterstitialAdUnitId = self.configuration?.rewardedInterstitialAdUnitId {
            rewardInterAd = RewardInterAdManager(adUnitId: rewardedInterstitialAdUnitId, adRequest: request, activePresentation: swiftlyRewardInterAd)
        }
        if let nativeAdUnitId = self.configuration?.nativeAdUnitId {
            nativeAd = NativeAdManager(adUnitId: nativeAdUnitId, adRequest: request, activePresentation: swiftlyNativeAd)
        }
        if let isTaggedForChildDirectedTreatment = self.configuration?.isTaggedForChildDirectedTreatment {
            self.configuration?.mediationConfigurator?.updateCOPPA(isTaggedForChildDirectedTreatment: isTaggedForChildDirectedTreatment)
            mobileAds.requestConfiguration.tagForChildDirectedTreatment = NSNumber(value: isTaggedForChildDirectedTreatment)
        }
        if let config = self.configuration {
            consentManager = AdsConsentManager(configuration: config, mobileAds: mobileAds)
        }
    }
    func updateConfiguration(_ updates: (SwiftlyAdsConfiguration) -> SwiftlyAdsConfiguration) {
        interstitialAd?.stopLoading()
        appOpenAd?.stopLoading()
        rewardAd?.stopLoading()
        rewardInterAd?.stopLoading()
        nativeAd?.stopLoading()
        let currentConfig = getCurrentConfiguration()
        let newConfig = updates(currentConfig)
        configure(newConfig)
        if self.configuration?.isPreLoadAds ?? false { Task { try? await loadAds() } }
    }
    @MainActor
    @discardableResult
    func showInterstitialAd(from viewController: UIViewController, skipCount: Bool = false) -> SwiftlyInterAd {
        guard !isDisabled else {
            doWork(after: 0.1) { self.swiftlyInterAd.onClose?() }
            return swiftlyInterAd
        }
        guard let interstraitlAd = interstitialAd else {
            doWork(after: 0.1) { self.swiftlyInterAd.onError?(SwiftlyAdError.interStrialAdUnitIdNotSet) }
            return swiftlyInterAd
        }
        if !skipCount {
            guard interAdCounter % (configuration?.interAdShowCount ?? 1) == 0 else {
                interAdCounter += 1
                doWork(after: 0.1) { self.swiftlyInterAd.onClose?() }
                return swiftlyInterAd
            }
        }
        guard hasConsent else {
            doWork(after: 0.1) { self.swiftlyInterAd.onError?(SwiftlyAdError.consentNotObtained) }
            return swiftlyInterAd
        }
        if let isPreload = self.configuration?.isPreLoadAds, !isPreload {
            Task {
                do {
                    try await interstraitlAd.loadAd()
                    interstraitlAd.show(from: viewController)
                    if !skipCount { interAdCounter += 1 }
                } catch {
                    doWork(after: 0.1) { self.swiftlyInterAd.onError?(error) }
                }
            }
        } else {
            interstraitlAd.show(from: viewController)
            if !skipCount { interAdCounter += 1 }
        }
        return swiftlyInterAd
    }
    @MainActor
    @discardableResult
    func showAppOpenAd(from viewController: UIViewController, skipCount: Bool = false) -> SwiftlyAppOpenAd {
        guard !isDisabled else {
            doWork(after: 0.1) { self.swiftlyAppOpenAd.onClose?() }
            return swiftlyAppOpenAd
        }
        guard let appOpenAd = appOpenAd else {
            doWork(after: 0.1) { self.swiftlyAppOpenAd.onError?(SwiftlyAdError.appOpenAdUnitIdNotSet) }
            return swiftlyAppOpenAd
        }
        if !skipCount {
            guard appOpenAdCounter % (configuration?.appOpenAdShowCount ?? 1) == 0 else {
                appOpenAdCounter += 1
                doWork(after: 0.1) { self.swiftlyAppOpenAd.onClose?() }
                return swiftlyAppOpenAd
            }
        }
        guard hasConsent else {
            doWork(after: 0.1) { self.swiftlyAppOpenAd.onError?(SwiftlyAdError.consentNotObtained) }
            return swiftlyAppOpenAd
        }
        if let isPreload = self.configuration?.isPreLoadAds, !isPreload {
            Task {
                do {
                    try await appOpenAd.loadAd()
                    appOpenAd.show(from: viewController)
                    if !skipCount { appOpenAdCounter += 1 }
                } catch {
                    doWork(after: 0.1) { self.swiftlyAppOpenAd.onError?(error) }
                }
            }
        } else {
            appOpenAd.show(from: viewController)
            if !skipCount { appOpenAdCounter += 1 }
        }
        return swiftlyAppOpenAd
    }
    @MainActor
    @discardableResult
    func showRewardAd(from viewController: UIViewController) -> SwiftlyRewardAd {
        guard !isDisabled else {
            doWork(after: 0.1) { self.swiftlyRewardAd.onClose?() }
            return swiftlyRewardAd
        }
        guard let rewardAd = rewardAd else {
            doWork(after: 0.1) { self.swiftlyRewardAd.onError?(SwiftlyAdError.rewardedAdUnitIdNotSet) }
            return swiftlyRewardAd
        }
        guard hasConsent else {
            doWork(after: 0.1) { self.swiftlyRewardAd.onError?(SwiftlyAdError.consentNotObtained) }
            return swiftlyRewardAd
        }
        if let isPreload = self.configuration?.isPreLoadAds, !isPreload {
            Task {
                do {
                    try await rewardAd.loadAd()
                    rewardAd.show(from: viewController)
                } catch {
                    doWork(after: 0.1) { self.swiftlyRewardAd.onError?(error) }
                }
            }
        } else {
            rewardAd.show(from: viewController)
        }
        return swiftlyRewardAd
    }
    @MainActor
    @discardableResult
    func showRewardInterAd(from viewController: UIViewController) -> SwiftlyRewardInterAd {
        guard !isDisabled else {
            doWork(after: 0.1) { self.swiftlyRewardInterAd.onClose?() }
            return swiftlyRewardInterAd
        }
        guard let rewardInterAd = rewardInterAd else {
            doWork(after: 0.1) { self.swiftlyRewardInterAd.onError?(SwiftlyAdError.rewardedInterAdUnitIdNotSet) }
            return swiftlyRewardInterAd
        }
        guard hasConsent else {
            doWork(after: 0.1) { self.swiftlyRewardInterAd.onError?(SwiftlyAdError.consentNotObtained) }
            return swiftlyRewardInterAd
        }
        if let isPreload = self.configuration?.isPreLoadAds, !isPreload {
            Task {
                do {
                    try await rewardInterAd.loadAd()
                    rewardInterAd.show(from: viewController)
                } catch {
                    doWork(after: 0.1) { self.swiftlyRewardInterAd.onError?(error) }
                }
            }
        } else {
            rewardInterAd.show(from: viewController)
        }
        return swiftlyRewardInterAd
    }
    @discardableResult
    func getNativeAd(skipCount: Bool = false) -> SwiftlyNativeAd {
        guard !isDisabled else {
            doWork(after: 0.1) { self.swiftlyNativeAd.onReciveAd?(nil) }
            return swiftlyNativeAd
        }
        guard let nativeAd = nativeAd else {
            doWork(after: 0.1) { self.swiftlyNativeAd.onError?(SwiftlyAdError.nativeAdUnitIdNotSet) }
            return swiftlyNativeAd
        }
        if !skipCount {
            guard nativeAdCounter % (configuration?.nativeAdShowCount ?? 1) == 0 else {
                nativeAdCounter += 1
                doWork(after: 0.1) { self.swiftlyNativeAd.onReciveAd?(nil) }
                return swiftlyNativeAd
            }
        }
        guard hasConsent else {
            doWork(after: 0.1) { self.swiftlyNativeAd.onError?(SwiftlyAdError.consentNotObtained) }
            return swiftlyNativeAd
        }
        doWork(after: 0.1) {
            self.swiftlyNativeAd.onReciveAd?(nativeAd.getNextAd())
            if !skipCount { self.nativeAdCounter += 1 }
            if self.configuration?.isPreLoadAds ?? false { nativeAd.loadAd(isPreloadAds: self.configuration?.isPreLoadAds ?? false) }
        }
        return swiftlyNativeAd
    }
    @MainActor
    func showBannerView(adFormate: SwiftlyBannerAdFormate, isCollapsible: Bool = false, onShow: (() -> Void)? = nil) -> SwiftlyBannerAdView? {
        guard !isDisabled else { return nil }
        guard let unitId = configuration?.bannerAdUnitId else { return nil }
        guard hasConsent else { return nil }
        return SwiftlyBannerAdView(adUnitID: unitId, isCollapsible: isCollapsible, adFormate: adFormate, onShow: onShow)
    }
    func updateConsent(from viewController: UIViewController) async throws -> ConsentStatus {
        guard let consentManager = consentManager else { throw SwiftlyAdError.consentManagerNotAvailable }
        try await consentManager.request(from: viewController)
        return consentManager.consentStatus
    }
    func setDisabled(_ isDisabled: Bool) {
        disabled = isDisabled
        if isDisabled {
            interstitialAd?.stopLoading()
            rewardAd?.stopLoading()
            rewardInterAd?.stopLoading()
            appOpenAd?.stopLoading()
            nativeAd?.stopLoading()
        } else {
            Task { [weak self] in try await self?.loadAds() }
        }
    }
}

public extension SwiftlyAds {
    var consentStatus: ConsentStatus { consentManager?.consentStatus ?? .notRequired }
    var isInterstitialAdReady: Bool { interstitialAd?.isReady ?? false }
    var isAppOpenAdReady: Bool { appOpenAd?.isReady ?? false }
    var isRewardAdReady: Bool { rewardAd?.isReady ?? false }
    var isRewardInterAdReady: Bool { rewardInterAd?.isReady ?? false }
    var isDisabled: Bool { disabled }
}

extension SwiftlyAds {
    func getCurrentConfiguration() -> SwiftlyAdsConfiguration {
        let config = SwiftlyAdsConfiguration()
        if let currentConfig = configuration {
            config
                .bannerAdUnitId(currentConfig.bannerAdUnitId)
                .interstitialAdUnitId(currentConfig.interstitialAdUnitId)
                .rewardedAdUnitId(currentConfig.rewardedAdUnitId)
                .rewardedInterstitialAdUnitId(currentConfig.rewardedInterstitialAdUnitId)
                .appOpenAdUnitId(currentConfig.appOpenAdUnitId)
                .nativeAdUnitId(currentConfig.nativeAdUnitId)
                .isTaggedForChildDirectedTreatment(currentConfig.isTaggedForChildDirectedTreatment)
                .isTaggedForUnderAgeOfConsent(currentConfig.isTaggedForUnderAgeOfConsent)
                .isPreLoadAds(currentConfig.isPreLoadAds ?? false)
                .mediationConfigurator(currentConfig.mediationConfigurator)
                .testDeviceIdentifiers(currentConfig.testDeviceIdentifiers)
                .geography(currentConfig.geography)
                .resetsConsentOnLaunch(currentConfig.resetsConsentOnLaunch)
                .interAdShowCount(currentConfig.interAdShowCount)
                .appOpenAdShowCount(currentConfig.appOpenAdShowCount)
                .nativeAdShowCount(currentConfig.nativeAdShowCount)
                .setEnvironment(currentConfig.environment)
                .adRequest(currentConfig.adRequest)
        }
        return config
    }
    func loadAds() async throws {
        guard !disabled else { return }
        if let nativeAd, !nativeAd.isReady { nativeAd.loadAd(isPreloadAds: self.configuration?.isPreLoadAds ?? false) }
        if let rewardAd, !rewardAd.isReady { try await rewardAd.loadAd() }
        if let interstitialAd, !interstitialAd.isReady { try await interstitialAd.loadAd() }
        if let rewardInterAd, !rewardInterAd.isReady { try await rewardInterAd.loadAd() }
        if let appOpenAd, !appOpenAd.isReady { try await appOpenAd.loadAd() }
    }
}
