//
//  NotificationServiceProvider.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 27.02.2024.
//

import Foundation
import UserNotifications

// MARK: - THEN TEST ALL FUNCTIONS, maybe edit main event creating

class NotificationServiceProvider {
    
    // MARK: - Scheduling Notification
    static func scheduleEvent(event: MainEvent){
        switch event.eventType{
            
        case .birthday:
            
            // MARK: - TODO in birhday and anniversary check scheduling
            let sdRequest = sameDayRequest(event: event)
            let dBeforeRequest = dayBeforeRequest(event: event)
            self.schedule(request: sdRequest)
            self.schedule(request: dBeforeRequest)
            
        case .anniversary:
            let sdRequest = sameDayRequest(event: event)
            let dBeforeRequest = dayBeforeRequest(event: event)
            self.schedule(request: sdRequest)
            self.schedule(request: dBeforeRequest)
            
        case .simpleEvent:
            let request = eventRequest(event: event)
            self.schedule(request: request)
        }
    }
    
    // MARK: - RAW REQUEST
   
    
    private static func schedule(request: UNNotificationRequest){
        
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
    
    // MARK: - SAME DAY EVENT
    
    private static func prepareDaySameDate(event: MainEvent) -> DateComponents {
        return DateComponents()
    }
        
    static func sameDayRequest(event: MainEvent) -> UNNotificationRequest{
        assert(event.notificationSameDayId != nil)
        // set up content
        let content = prepareContent(event: event)
        
        // set up date
        let dateComponents = prepareEventTime(event: event)
        
        // set up trigger
        let trigger = self.prepareTrigger(event: event, dateComponents: dateComponents)
        
        let request = UNNotificationRequest(identifier: event.notificationSameDayId!, content: content, trigger: trigger)
        
        return request
    }
    
    // MARK: - DAYS BEFORE EVENT
    
    private static func prepareDaysBeforeDate(event: MainEvent) -> DateComponents {
        return DateComponents()
    }
    
    static func dayBeforeRequest(event: MainEvent) -> UNNotificationRequest{
        assert(event.notificationDaysBeforeId != nil)
        // set up content
        let content = prepareContent(event: event)
        
        // set up date
        let dateComponents = prepareEventTime(event: event)
        
        // set up trigger
        let trigger = self.prepareTrigger(event: event, dateComponents: dateComponents)
        
        let request = UNNotificationRequest(identifier: event.notificationDaysBeforeId!, content: content, trigger: trigger)
        
        return request
    }
    
    // MARK: - EVENT TIME
    
    private static func prepareEventTime(event: MainEvent) -> DateComponents{
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: event.eventDate)
        NSLog("next event notification of \(event.title) on : \(comps)")
        return comps
    }
    
    static func eventRequest(event: MainEvent) -> UNNotificationRequest{
        assert(event.notificationEventId != nil)
        // set up content
        let content = prepareContent(event: event)
        
        // set up date
        let dateComponents = prepareEventTime(event: event)
        
        // set up trigger
        let trigger = self.prepareTrigger(event: event, dateComponents: dateComponents)
        
        let request = UNNotificationRequest(identifier: event.notificationEventId!, content: content, trigger: trigger)
        
        return request
    }
    
    // MARK: - GENERAL
    private static func prepareTrigger(event: MainEvent, dateComponents: DateComponents) -> UNCalendarNotificationTrigger{
        // don't repeat simple event
        if event.eventType == .simpleEvent {
            return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        }
        // repeat birthday and anniversary
        return UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
    }
    
    private static func prepareContent(event: MainEvent) -> UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = event.title
        return content
    }
    
    // MARK: - DELETING NOTIFICATION
    static func cancelAllNotifications(){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    static func cancelNotifications(ids: [String]){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeDeliveredNotifications(withIdentifiers: ids)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
    }
}
