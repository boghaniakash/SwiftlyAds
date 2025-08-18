//
//  InterManager.swift
//  StandOut
//
//  Created by iOS Developer on 11/04/25.
//

import GoogleMobileAds

final class InterAdManager: NSObject, @unchecked Sendable {
    // MARK: - Private + Properties
    private let adUnitId: String
    private let adRequest: SwiftlyAdRequest
    private let activePresentation: SwiftlyInterAd
    private var interstitialAd: InterstitialAd?
    
    // MARK: - Init
    init(adUnitId: String, adRequest: SwiftlyAdRequest, activePresentation: SwiftlyInterAd) {
        self.adUnitId = adUnitId
        self.adRequest = adRequest
        self.activePresentation = activePresentation
    }
}

extension InterAdManager {
    var isReady: Bool { interstitialAd != nil }
    func loadAd() async throws {
        interstitialAd = try await InterstitialAd.load(with: adUnitId, request: adRequest)
        interstitialAd?.fullScreenContentDelegate = self
    }
    func stopLoading() {
        interstitialAd?.fullScreenContentDelegate = nil
        interstitialAd = nil
    }
    @MainActor
    func show(from viewController: UIViewController) {
        if let interstitialAd = interstitialAd {
            do {
                try interstitialAd.canPresent(from: viewController)
                interstitialAd.present(from: viewController)
            } catch {
                reload()
                activePresentation.onError?(error)
            }
        } else {
            reload()
            doWork(after: 0.1) { [weak self] in self?.activePresentation.onError?(SwiftlyAdError.interstitialAdNotLoaded) }
        }
    }
}

extension InterAdManager: FullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        doWork(after: 0.1) { [weak self] in self?.activePresentation.onOpen?() }
    }
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        interstitialAd = nil
        doWork(after: 0.1) { [weak self] in self?.activePresentation.onClose?() }
        reload()
    }
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        doWork(after: 0.1) { [weak self] in self?.activePresentation.onError?(error) }
    }
}

private extension InterAdManager {
    func reload() { Task { try await loadAd() } }
}
