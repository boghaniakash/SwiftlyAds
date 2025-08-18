//
//  SwiftlyAdsConsentManager.swift
//  SwiftlyAds
//
//  Created by Akash Boghani on 08/08/25.
//

@preconcurrency import UserMessagingPlatform
@preconcurrency import GoogleMobileAds

final class AdsConsentManager: Sendable {
    // MARK: - Private + Properties
    private let configuration: SwiftlyAdsConfigurationProvider
    private let consentInformation: ConsentInformation
    private let mobileAds: MobileAds

    // MARK: - Initialization
    init(configuration: SwiftlyAdsConfigurationProvider,
         mobileAds: MobileAds) {
        self.configuration = configuration
        self.consentInformation = .shared
        self.mobileAds = mobileAds
    }
}

// MARK: - AdsConsentManager
extension AdsConsentManager {
    var consentStatus: ConsentStatus { consentInformation.consentStatus }
    @MainActor func request(from viewController: UIViewController) async throws {
        defer {
            if consentStatus != .notRequired { configure(for: consentStatus) }
        }
        try await requestUpdate()
        switch consentInformation.formStatus {
        case .available:
            let form = try await ConsentForm.load()
            try await form.present(from: viewController)
        default: break
        }
    }
}

// MARK: - Private Methods
private extension AdsConsentManager {
    func requestUpdate() async throws {
        let parameters = RequestParameters()
        parameters.isTaggedForUnderAgeOfConsent = configuration.isTaggedForUnderAgeOfConsent ?? false
        if configuration.environment == .development {
            let debugSettings = DebugSettings()
            debugSettings.testDeviceIdentifiers = configuration.testDeviceIdentifiers
            debugSettings.geography = configuration.geography
            parameters.debugSettings = debugSettings
            if configuration.resetsConsentOnLaunch { consentInformation.reset() }
        }
        try await consentInformation.requestConsentInfoUpdate(with: parameters)
    }
    func configure(for consentStatus: ConsentStatus) {
        configuration.mediationConfigurator?.updateGDPR(for: consentStatus, isTaggedForUnderAgeOfConsent: configuration.isTaggedForUnderAgeOfConsent ?? false)
        guard !(configuration.isTaggedForChildDirectedTreatment ?? false) else { return }
        mobileAds.requestConfiguration.tagForUnderAgeOfConsent = NSNumber(value: configuration.isTaggedForUnderAgeOfConsent ?? false)
    }
}
