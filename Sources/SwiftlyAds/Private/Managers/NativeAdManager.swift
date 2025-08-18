//
//  NativeAdManager.swift
//  SwiftlyAds
//
//  Created by iOS Developer on 11/04/25.
//

import GoogleMobileAds

final class NativeAdManager: NSObject, @unchecked Sendable {
    // MARK: - Private
    private let adUnitId: String
    private let adRequest: SwiftlyAdRequest
    private let activePresentation: SwiftlyNativeAd
    private var adLoader: AdLoader?
    private var preLoadedAds: [NativeAd] = []
    private var adLimit: Int = 1
    
    // MARK: - Init
    init(adUnitId: String, adRequest: SwiftlyAdRequest, activePresentation: SwiftlyNativeAd) {
        self.adUnitId = adUnitId
        self.adRequest = adRequest
        self.activePresentation = activePresentation
    }
}

extension NativeAdManager {
    var isReady: Bool { !preLoadedAds.isEmpty }
    func loadAd() {
        adLoader = AdLoader(adUnitID: adUnitId, rootViewController: nil, adTypes: [.native], options: nil)
        adLoader?.delegate = self
        adLoader?.load(adRequest)
    }
    func stopLoading() {
        adLoader?.delegate = nil
        adLoader = nil
        preLoadedAds.removeAll()
    }
    func getNextAd() -> NativeAd? {
        if let ad = preLoadedAds.last { return ad }
        else { loadAd() }
        return nil
    }
}

// MARK: - Delegate
extension NativeAdManager: NativeAdLoaderDelegate {
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        cache(nativeAd)
    }
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        activePresentation.onError?(error)
    }
}

// MARK: - Private + Extension
private extension NativeAdManager {
    func cache(_ ad: NativeAd) {
        if preLoadedAds.count >= adLimit { preLoadedAds.removeFirst() }
        preLoadedAds.append(ad)
    }
}
