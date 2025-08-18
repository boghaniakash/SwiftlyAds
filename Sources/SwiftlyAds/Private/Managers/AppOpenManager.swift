//
//  File.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 07/08/25.
//

import GoogleMobileAds

final class AppOpenAdManager: NSObject, @unchecked Sendable {
    // MARK: - Private + Properties
    private let adUnitId: String
    private let adRequest: SwiftlyAdRequest
    private let activePresentation: SwiftlyAppOpenAd
    private var appOpenAd: AppOpenAd?
    
    // MARK: - Init
    init(adUnitId: String, adRequest: SwiftlyAdRequest, activePresentation: SwiftlyAppOpenAd) {
        self.adUnitId = adUnitId
        self.adRequest = adRequest
        self.activePresentation = activePresentation
    }
}

extension AppOpenAdManager {
    var isReady: Bool { appOpenAd != nil }
    func loadAd() async throws {
        appOpenAd = try await AppOpenAd.load(with: adUnitId, request: adRequest)
        appOpenAd?.fullScreenContentDelegate = self
    }
    func stopLoading() {
        appOpenAd?.fullScreenContentDelegate = nil
        appOpenAd = nil
    }
    @MainActor
    func show(from viewController: UIViewController) {
        if let appOpenAd = appOpenAd {
            do {
                try appOpenAd.canPresent(from: viewController)
                appOpenAd.present(from: viewController)
            } catch {
                reload()
                activePresentation.onError?(error)
            }
        } else {
            reload()
            doWork(after: 0.1) { [weak self] in self?.activePresentation.onError?(SwiftlyAdError.appOpenAdNotLoaded) }
        }
    }
}

extension AppOpenAdManager: FullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        doWork(after: 0.1) { [weak self] in self?.activePresentation.onOpen?() }
    }
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        appOpenAd = nil
        doWork(after: 0.1) { [weak self] in self?.activePresentation.onClose?() }
        reload()
    }
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        doWork(after: 0.1) { [weak self] in self?.activePresentation.onError?(error) }
    }
}

private extension AppOpenAdManager {
    func reload() { Task { try await loadAd() } }
}

