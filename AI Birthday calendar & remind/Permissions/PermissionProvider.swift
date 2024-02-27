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
    
    // MARK: - Scheduling Notification
    static func scheduleNotification(event: MainEvent) -> MainEvent{
        
        // set up content
        let content = prepareContent(event: event)
        
        // set up date
        let dateComponents = prepareDate(event: event)
        
        // set up trigger
        let trigger = self.prepareTrigger(event: event, dateComponents: dateComponents)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        //!!!!CHECK PERMISSION and handle error it's very IMPORTANT
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        // Save notification id
        event.notificationIds.append(uuidString)
        notificationCenter.add(request) {error in
            NSLog("error while notification adding: \(String(describing: error))")
        }
        
        return event
    }
    
    private static func prepareContent(event: MainEvent) -> UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = "test"
        return content
    }
    
    private static func prepareDate(event: MainEvent) -> DateComponents{
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        dateComponents.weekday = 3  // Tuesday
        dateComponents.hour = 14    // 14:00 hours
        return dateComponents
    }
    
    private static func prepareTrigger(event: MainEvent, dateComponents: DateComponents) -> UNCalendarNotificationTrigger{
        return UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
    }
    
    // MARK: - DELETING NOTIFICATION
    private static func cancelNotifications(event: MainEvent){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeDeliveredNotifications(withIdentifiers: event.notificationIds)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: event.notificationIds)
    }
}
