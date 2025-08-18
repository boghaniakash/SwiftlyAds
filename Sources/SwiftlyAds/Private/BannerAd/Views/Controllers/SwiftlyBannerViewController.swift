//
//  SwiftlyBannerViewController.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 18/08/25.
//

import UIKit

class SwiftlyBannerViewController: UIViewController {
    weak var delegate: SwiftlyBannerViewControllerWidthDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Task { await delegate?.bannerViewController(self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width) }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        coordinator.animate { _ in } completion: { _ in
            Task { await self.delegate?.bannerViewController(self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width) }
        }
    }
}
