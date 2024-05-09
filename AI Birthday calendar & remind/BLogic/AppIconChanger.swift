//
//  AppIconChanger.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 09.05.2024.
//

import UIKit

enum IconChangeErrors: Error {
    case notSupportedDevice
}

class AppIconChanger {
    
    static func resetIcon() {
        let name = UIApplication.shared.alternateIconName
        if name != nil && name != "AppIcon" {
            UIApplication.shared.setAlternateIconName(nil)
            AnalyticsManager.shared.logEvent(eventType: .premiumEndedIconRestored)
        }
    }
    static func changeIcon(name: String, completion:  @escaping (Error?) -> Void) {
        guard MonetizationConfiguration.isPremiumAccount else {
            resetIcon()
            return
        }
        
        UIApplication.shared.setAlternateIconName(name) { error in
            NSLog("📱 🏋️‍♀️ \(error?.localizedDescription ?? "nil error")")
            guard  UIApplication.shared.supportsAlternateIcons else {
                completion(IconChangeErrors.notSupportedDevice)
                return
            }
            return completion(error)
        }
        AnalyticsManager.shared.logEvent(eventType: .iconChanged)

    }
}
