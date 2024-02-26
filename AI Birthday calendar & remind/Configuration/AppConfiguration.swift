//
//  AppConfiguratino.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 21.02.2024.
//

import Foundation


class AppConfiguration {
    // MARK: - LINKS
    static var appStoreURL: String = ""
    static var launchedEarlier = SettingsStorage.loadIsFirstLaunch()
}
