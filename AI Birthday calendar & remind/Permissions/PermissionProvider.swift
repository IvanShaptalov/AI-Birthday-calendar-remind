//
//  PermissionProvider.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 27.02.2024.
//

import Foundation
import UserNotifications
import UIKit
import EventKit


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
    
    // MARK: - CALENDAR Events, Reminders
    static var evStore = EKEventStore()
    
    static func registerForEvents(completion: ((Bool, String) -> Void)? = nil) {
        NSLog("get permission events 📆")
        
        let authorizationStatus = EKEventStore.authorizationStatus(for: .event)
                            switch authorizationStatus {
                            case .notDetermined:
                                // only one case to request permission
                                break
                            case .restricted:
                                completion?(true, "restricted")
                                return
                            case .denied:
                                completion?(true, "denied")
                                return
                            case .authorized:
                                print("authorized")
                                completion?(false, "success")
                                return
                            case .fullAccess:
                                print("full access")
                                completion?(false, "success")
                                return
                            case .writeOnly:
                                completion?(true, "write only")
                                return
                            @unknown default:
                                completion?(true, "unknown")
                                return
                            }
        // MARK: - Check permission status
        if #available(iOS 17.0, *) {
            NSLog("🍏 IOS 17.0 + ")
            evStore.requestFullAccessToEvents(completion: { granted, error in
                if error == nil{
                    NSLog("granted 📆✅ \(granted)")
                    completion?(false, "success")

                } else {
                    NSLog("error while get event permission 🤖")
                    completion?(true, "error while get event permission")

                }
            })
        } else {
            NSLog("💽 IOS 17.0 <")
            evStore.requestAccess(to: .event, completion: {granted, error in
                if error == nil{
                    
                    NSLog("granted 📆✅ \(granted)")
                    completion?(false, "success")

                } else {
                    NSLog("error while get event permission 🤖")
                    completion?(true, "error while get event permission")

                }
            })
        }
    }
    
    static func registerForReminders(completion: ((Bool, String) -> Void)? = nil) {
        NSLog("get permission reminders ⏰")
        
        let authorizationStatus = EKEventStore.authorizationStatus(for: .reminder)
                            switch authorizationStatus {
                            case .notDetermined:
                                // only one case to request permission
                                break
                            case .restricted:
                                completion?(true, "restricted")
                                return
                            case .denied:
                                completion?(true, "denied")
                                return
                            case .authorized:
                                print("authorized")
                                completion?(false, "success")

                                return
                            case .fullAccess:
                                print("full access")
                                completion?(false, "success")

                                return
                            case .writeOnly:
                                completion?(true, "write only")
                                return
                            @unknown default:
                                completion?(true, "unknown")
                                return
                            }
        // MARK: - Check permission status
        
        if #available(iOS 17.0, *) {
            evStore.requestFullAccessToReminders(completion: { granted, error in
                if error == nil{
                    NSLog("granted ⏰✅ \(granted)")
                    completion?(false, "success")

                    
                } else {
                    NSLog("error while get event permission 🤖")
                    completion?(true, "error while get event permission")

                }
            })
        } else {
            NSLog("💽 IOS 17.0 <")
            evStore.requestAccess(to: .reminder, completion: {granted, error in
                if error == nil{
                    
                    NSLog("granted ⏰✅ \(granted)")
                    completion?(false, "success")

                } else {
                    NSLog("error while get event permission 🤖")
                    completion?(true, "error while get event permission")

                }
            })
        }
    }
    
    
}
