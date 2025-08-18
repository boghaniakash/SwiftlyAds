//
//  File.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 07/08/25.
//

import GoogleMobileAds

final class RewardAdManager: NSObject, @unchecked Sendable {
    // MARK: - Private + Properties
    private let adUnitId: String
    private let adRequest: SwiftlyAdRequest
    private let activePresentation: SwiftlyRewardAd
    private var rewardedAd: RewardedAd?
    
    // MARK: - Init
    init(adUnitId: String, adRequest: SwiftlyAdRequest, activePresentation: SwiftlyRewardAd) {
        self.adUnitId = adUnitId
        self.adRequest = adRequest
        self.activePresentation = activePresentation
    }
}

extension RewardAdManager {
    var isReady: Bool { rewardedAd != nil }
    func loadAd() async throws {
        rewardedAd = try await RewardedAd.load(with: adUnitId, request: adRequest)
        rewardedAd?.fullScreenContentDelegate = self
    }
    func stopLoading() {
        rewardedAd?.fullScreenContentDelegate = nil
        rewardedAd = nil
    }
    @MainActor
    func show(from viewController: UIViewController) {
        if let rewardedAd = rewardedAd {
            do {
                try rewardedAd.canPresent(from: viewController)
                let rewardAmount = rewardedAd.adReward.amount
                rewardedAd.present(from: viewController) { self.activePresentation.onReward?(rewardAmount) }
            } catch {
                reload()
                activePresentation.onError?(error)
            }
        } else {
            reload()
            doWork(after: 0.1) { [weak self] in self?.activePresentation.onError?(SwiftlyAdError.rewardedAdNotLoaded) }
        }
    }
}

extension RewardAdManager: FullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        doWork(after: 0.1) { [weak self] in self?.activePresentation.onOpen?() }
    }
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        rewardedAd = nil
        doWork(after: 0.1) { [weak self] in self?.activePresentation.onClose?() }
        reload()
    }
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        doWork(after: 0.1) { [weak self] in self?.activePresentation.onError?(error) }
    }
}

private extension RewardAdManager {
    func reload() { Task { try await loadAd() } }
}

