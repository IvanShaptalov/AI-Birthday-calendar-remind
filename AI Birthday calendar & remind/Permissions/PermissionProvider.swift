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
    
    // MARK: - CALENDAR
    static var evStore = EKEventStore()
    
    static func registerForEvents(completion: ((Bool, String) -> Void)? = nil) {
        NSLog("get permission events 📆")
        
        if !checkAuthorizationStatus(completion: completion, forType: .event){
            return
        }
        
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
    
    // MARK: - REMINDERS
    static func registerForReminders(completion: ((Bool, String) -> Void)? = nil) {
        NSLog("get permission reminders ⏰")
        
        if !checkAuthorizationStatus(completion: completion, forType: .reminder){
            return
        }
        
        
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
    
    
    // if returns true, continue execution, else break outer functions
    private static func checkAuthorizationStatus(completion: ((Bool, String) -> Void)?, forType: EKEntityType) -> Bool{
        let authorizationStatus = EKEventStore.authorizationStatus(for: forType)
        switch authorizationStatus {
        case .notDetermined:
            // only one case to request permission
            return true
        case .restricted, .denied, .writeOnly:
            completion?(true, "authorization code: \(authorizationStatus.rawValue)")
            return false
        case .authorized, .fullAccess:
            print("authorized")
            completion?(false, "success")
            return false
            
        @unknown default:
            completion?(true, "unknown")
            return false
        }
    }
    
    static func checkCalendarAccess(forType: EKEntityType) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var grantedAccess = false
        
        if #available(iOS 17.0, *) {
            if forType == .reminder {
                evStore.requestFullAccessToReminders(completion: { granted, error in
                    grantedAccess = granted
                    semaphore.signal()
                    
                })
            } else {
                evStore.requestFullAccessToEvents(completion: { granted, error in
                    grantedAccess = granted
                    semaphore.signal()
                    
                })
            }
            
        } else {
            NSLog("💽 IOS 17.0 <")
            evStore.requestAccess(to: forType, completion: {granted, error in
                if error == nil{
                    grantedAccess = granted
                    semaphore.signal()
                    
                } else {
                    grantedAccess = granted
                    semaphore.signal()
                    
                }
            })
        }

        semaphore.wait()
        NSLog("🧵 granted after semaphore: \(grantedAccess)")
        return grantedAccess
    }
    
    
}
