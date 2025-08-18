//
//  BannerView.swift
//  AdMobSetup_SwiftUI
//
//  Created by KPEWORLD on 19/07/24.
//

import SwiftUI
import GoogleMobileAds

public struct SwiftlyBannerAdView: View {
    // MARK: - Private + @State
    @State private var adStatus: SwiftlyBannerAdStatus = .loading
    
    // MARK: - Private + Properties
    private let adUnitID: String
    private let isCollapsible: Bool
    private let adFormate: SwiftlyBannerAdFormate
    private var onShow: (() -> Void)?
    
    // MARK: - Public + Init
    init(adUnitID: String, isCollapsible: Bool, adFormate: SwiftlyBannerAdFormate, onShow: (() -> Void)?) {
        self.adUnitID = adUnitID
        self.isCollapsible = isCollapsible
        self.adFormate = adFormate
        self.onShow = onShow
    }
    
    // MARK: - Body
    public var body: some View {
        HStack {
            if adStatus != .failure {
                SwiftlyBannerView(adSize: adFormate.adSize, isCollapsible: isCollapsible, adUnitID: adUnitID, adStatus: $adStatus)
                    .frame(width: adFormate.size.width, height: adFormate.size.height)
                    .onChange(of: adStatus) { if $0 == .success { onShow?() } }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

