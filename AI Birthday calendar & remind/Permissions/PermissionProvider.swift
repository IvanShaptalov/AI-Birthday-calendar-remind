//
//  PermissionProvider.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 27.02.2024.
//

import Foundation
import UserNotifications
import UIKit


class PermissionProvider {
    // MARK: - NOTIFICATION
    static let notificationCenter = UNUserNotificationCenter.current()
    
    static func registerForRemoteNotification(userDeniedNotification: ((Bool) -> Void)? = nil) {
        NSLog("get notification permission 🔔")
        // MARK: - Check permission status
        notificationCenter.getNotificationSettings(completionHandler: { (settings) in
            // if user denied notification
            let authorizationStatus = settings.authorizationStatus
            NSLog("\(authorizationStatus)")
            if authorizationStatus == .denied{
                userDeniedNotification?(true)
            }
            notificationCenter.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    NSLog("\(granted)")
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        
                        if granted{
                            NSLog("notification permission: 🔔 ✅")
                        } else {
                            NSLog("not granted 🔕")
                        }
                    }
                } else {
                    
                    NSLog("error 🔕")
                    
                }
            }
        }
        )
    }
}
