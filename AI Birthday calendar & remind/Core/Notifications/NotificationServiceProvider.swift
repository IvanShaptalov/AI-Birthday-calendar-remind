//
//  NotificationServiceProvider.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 27.02.2024.
//

import Foundation
import UserNotifications


class NotificationServiceProvider {
    
    // MARK: - Scheduling Notification
    static func scheduleNotification(event: MainEvent) -> [String]{
        if !event.notificationIds.isEmpty{
            NSLog("event notification ids clearing: \(event.notificationIds)")
            cancelNotifications(event: event)
        }
        
        NSLog("event notification now: \(event.notificationIds.count)")
        // set up content
        let content = prepareContent(event: event)
        
        // set up date
        let dateComponents = prepareDate(event: event)
        
        // set up trigger
        let trigger = self.prepareTrigger(event: event, dateComponents: dateComponents)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        self.rawScheduleNotification(request: request)
        
        return [uuidString]
    }
    
    private static func rawScheduleNotification(request: UNNotificationRequest){
        
        PermissionProvider.notificationCenter.getNotificationSettings(completionHandler: {settings in
            NSLog("scheduling notification 🔔")
            guard (settings.authorizationStatus == .authorized) ||
                    (settings.authorizationStatus == .provisional) else { return }
            
            PermissionProvider.notificationCenter.add(request) {error in
                NSLog("error while notification adding: \(String(describing: error))")
            }
        }
        )
    }
    
    private static func prepareContent(event: MainEvent) -> UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = event.title
        return content
    }
    
    private static func prepareDate(event: MainEvent) -> DateComponents{
        if event.eventType == .simpleEvent {

            let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: event.eventDate)
            NSLog("next notification of \(event.title) on : \(comps)")
            return comps
        }
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.weekday = 3  // Tuesday
        dateComponents.hour = 14    // 14:00 hours
        return dateComponents
    }
    
    private static func prepareTrigger(event: MainEvent, dateComponents: DateComponents) -> UNCalendarNotificationTrigger{
        // don't repeat simple event
        if event.eventType == .simpleEvent {
            return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        }
        // repeat birthday and anniversary
        return UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
    }
    
    // MARK: - DELETING NOTIFICATION
    static func cancelNotifications(event: MainEvent){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeDeliveredNotifications(withIdentifiers: event.notificationIds)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: event.notificationIds)
    }
}
