//
//  AppConfiguratino.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 21.02.2024.
//

import Foundation


class AppConfiguration {
    // MARK: - LINKS
    static var appStoreURL: String = "https://www.instagram.com/wellbeingvantage/"
    static var privacyPolicyURL: String = "https://t.me/aibcrprivacyPolicy"
    static var contactUsURL: String = "https://www.instagram.com/wellbeingvantage/"
    static var launchedEarlier = SettingsStorage.loadIsFirstLaunch()
}
