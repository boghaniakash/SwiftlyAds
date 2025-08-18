//
//  RewardInterManager.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 07/08/25.
//

import GoogleMobileAds

final class RewardInterAdManager: NSObject, @unchecked Sendable {
    // MARK: - Private + Properties
    private let adUnitId: String
    private let adRequest: SwiftlyAdRequest
    private let activePresentation: SwiftlyRewardInterAd
    private var rewardedInterstitialAd: RewardedInterstitialAd?
    
    // MARK: - Init
    init(adUnitId: String, adRequest: SwiftlyAdRequest, activePresentation: SwiftlyRewardInterAd) {
        self.adUnitId = adUnitId
        self.adRequest = adRequest
        self.activePresentation = activePresentation
    }
}

extension RewardInterAdManager {
    var isReady: Bool { rewardedInterstitialAd != nil }
    func loadAd() async throws {
        rewardedInterstitialAd = try await RewardedInterstitialAd.load(with: adUnitId, request: adRequest)
        rewardedInterstitialAd?.fullScreenContentDelegate = self
    }
    func stopLoading() {
        rewardedInterstitialAd?.fullScreenContentDelegate = nil
        rewardedInterstitialAd = nil
    }
    @MainActor
    func show(from viewController: UIViewController) {
        if let rewardedInterstitialAd = rewardedInterstitialAd {
            do {
                try rewardedInterstitialAd.canPresent(from: viewController)
                let rewardAmount = rewardedInterstitialAd.adReward.amount
                rewardedInterstitialAd.present(from: viewController) { self.activePresentation.onReward?(rewardAmount) }
            } catch {
                reload()
                activePresentation.onError?(error)
            }
        } else {
            reload()
            doWork(after: 0.1) { [weak self] in self?.activePresentation.onError?(SwiftlyAdError.rewardedInterAdNotLoaded) }
        }
    }
}

extension RewardInterAdManager: FullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        doWork(after: 0.1) { [weak self] in self?.activePresentation.onOpen?() }
    }
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        rewardedInterstitialAd = nil
        doWork(after: 0.1) { [weak self] in self?.activePresentation.onClose?() }
        reload()
    }
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        doWork(after: 0.1) { [weak self] in self?.activePresentation.onError?(error) }
    }
}

private extension RewardInterAdManager {
    func reload() { Task { try await loadAd() } }
}

