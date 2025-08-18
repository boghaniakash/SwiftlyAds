//
//  SwiftlyBannerViewControllerWidthDelegate.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 18/08/25.
//

import Foundation

protocol SwiftlyBannerViewControllerWidthDelegate: AnyObject, Sendable {
    @MainActor func bannerViewController(_ bannerViewController: SwiftlyBannerViewController, didUpdate width: CGFloat) async
}
