//
//  RateAppProvider.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 26.02.2024.
//

import Foundation
import UIKit
import StoreKit

class RateProvider {
    
    
    static private func saveRating(version: String?, isRatedBefore: Bool){
        NSLog("app version: \(version ?? "nil")")
        if version != nil {
            SettingsStorage.saveAppVersion(appVersion: version!)
        }
        
        SettingsStorage.saveRatedBefore(isRatedBefore: isRatedBefore)
        
    }
    
    static private func isNeedToRate() -> Bool {
        let appVersion: String? = SettingsStorage.loadAppVersion()
        let isRated: Bool = SettingsStorage.loadRatedBefore()
        
        if (appVersion == nil){
            NSLog("app version is nil, -> true")
            return true
        }
        
        if (self.appVersion != appVersion) {
            NSLog("new version, -> true")
            return true
        }
        
        if (!isRated){
            NSLog("not rated, -> true")
            return true
        }
        
        NSLog("app version same, rated true, -> false")
        
        return false
        
        
        
    }
    
    static func rateApp() {
        AnalyticsManager.shared.logEvent(eventType: .rateAppDirect)
        UIApplication.shared.open(URL(string: AppConfiguration.appStoreURL)!, options: [:], completionHandler: nil)
        
    }
    
    /// rate app if version not same, or app not rated earlier
    static func rateAppImplicit(view: UIView) {
        NSLog("try rate 🤞")
        if isNeedToRate() {
            NSLog("rate ⭐️")
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
                saveRating(version: self.appVersion, isRatedBefore: true)
                AnalyticsManager.shared.logEvent(eventType: .rateAppImplicitA)
            }
        } else {
            NSLog("no need rate 🚫")
        }
    }
    
    static private var appVersion: String? {
        guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String else {
            return nil
        }
        return currentVersion
    }
}
