// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let packageName = "SwiftlyAds"

let package = Package(
    name: packageName,
    platforms: [.iOS(.v15)],
    products: [.library(name: packageName, targets: [packageName])],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "12.11.0")
    ],
    targets: [
        .target(
            name: packageName,
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ],
            path: "Sources"
        )
    ]
)
