//
//  SwiftlyBannerAdFormate.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 18/08/25.
//

import SwiftUI
import GoogleMobileAds

@MainActor
public enum SwiftlyBannerAdFormate {
    case standartBanner
    case largeBanner
    case mediumRectangle
    case fullBanner
    case leaderBoard
    case skyscrapper
    case fluid
    case adaptiveBanner
}

extension SwiftlyBannerAdFormate {
    var adSize: AdSize {
        switch self {
        case .standartBanner: AdSizeBanner
        case .largeBanner: AdSizeLargeBanner
        case .mediumRectangle: AdSizeMediumRectangle
        case .fullBanner: AdSizeFullBanner
        case .leaderBoard: AdSizeLeaderboard
        case .skyscrapper: AdSizeSkyscraper
        case .fluid: AdSizeFluid
        case .adaptiveBanner: currentOrientationAnchoredAdaptiveBanner(width: UIScreen.main.bounds.size.width)
        }
    }
    var size: CGSize { adSize.size }
}
