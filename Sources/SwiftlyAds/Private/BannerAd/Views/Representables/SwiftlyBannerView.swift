//
//  SwiftlyBannerView.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 18/08/25.
//

import SwiftUI
import GoogleMobileAds

struct SwiftlyBannerView: UIViewControllerRepresentable  {
    // MARK: - Properties
    let adSize: AdSize
    let isCollapsible: Bool
    let adUnitID: String
    @Binding var adStatus: SwiftlyBannerAdStatus
    
    @State private var viewWidth: CGFloat = .zero
    private let bannerView = BannerView()
}

extension SwiftlyBannerView {
    func makeCoordinator() -> Coordinator { return Coordinator(parent: self) }
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = SwiftlyBannerViewController()
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = bannerViewController
        bannerView.delegate = context.coordinator
        bannerViewController.view.addSubview(bannerView)
        bannerViewController.delegate = context.coordinator
        return bannerViewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        bannerView.adSize = adSize
        let request = Request()
        if isCollapsible {
            let extras = Extras()
            extras.additionalParameters = ["collapsible" : "bottom"]
            request.register(extras)
        }
        bannerView.load(request)
    }
}

extension SwiftlyBannerView {
    class Coordinator: NSObject, SwiftlyBannerViewControllerWidthDelegate, BannerViewDelegate, @unchecked Sendable {
        // MARK: - Properties
        let parent: SwiftlyBannerView
        
        // MARK: - Life Cycle
        init(parent: SwiftlyBannerView) {
            self.parent = parent
        }
        
        // MARK: - Functions
        @MainActor func bannerViewController(_ bannerViewController: SwiftlyBannerViewController, didUpdate width: CGFloat) {
            parent.viewWidth = width
        }
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            parent.adStatus = .success
        }
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: any Error) {
            print("Banner Ad Fail: - \(error.localizedDescription)")
            parent.adStatus = .failure
        }
    }
}
