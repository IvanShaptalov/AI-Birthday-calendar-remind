//
//  NotificationServiceProvider.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 27.02.2024.
//

import Foundation
import UserNotifications

class NotificationServiceProvider {
    // MARK: - Scheduling Notification 📆
    static func scheduleEvent(event: MainEvent, notifDisabled ndc: (()-> Void)?){
        switch event.eventType{
            
        case .birthday:
            
            if event.notificationSameDayId != nil {
                NSLog("⏰ notify same day")
                let sdRequest = sameDayRequest(event: event)
                self.schedule(request: sdRequest,ndc)
            }
            
            if event.notificationDaysBeforeId != nil {
                NSLog("🗿 notify day before")
                let dBeforeRequest = dayBeforeRequest(event: event)
                if dBeforeRequest != nil {
                    self.schedule(request: dBeforeRequest!,ndc)
                }
            }
            
        case .anniversary:
            if event.notificationSameDayId != nil {
                NSLog("⏰ notify same day")
                let sdRequest = sameDayRequest(event: event)
                self.schedule(request: sdRequest,ndc)
            }
            
            if event.notificationDaysBeforeId != nil {
                NSLog("🗿 notify day before")
                let dBeforeRequest = dayBeforeRequest(event: event)
                if dBeforeRequest != nil {
                    
                    self.schedule(request: dBeforeRequest!,ndc)
                }
            }
            
        case .simpleEvent:
            NSLog("📅 notify event")
            let request = eventRequest(event: event)
            self.schedule(request: request,ndc)
        }
    }
    
    // MARK: - RAW REQUEST 🥦
    
    
    private static func schedule(request: UNNotificationRequest,_ notificationDisabledCallback: (()-> Void)?){
        
        PermissionProvider.notificationCenter.getNotificationSettings(completionHandler: {settings in
            DispatchQueue.main.async {
                
                NSLog("scheduling notification 🔔")
                guard (settings.authorizationStatus == .authorized) ||
                        (settings.authorizationStatus == .provisional) else {
                    notificationDisabledCallback?()
                    return }
                
                PermissionProvider.notificationCenter.add(request) {error in
                    NSLog("error while notification adding: \(String(describing: error))")
                }}
        }
        )
    }
    
    // MARK: - SAME DAY EVENT ☀️
    
    private static func prepareDaySameDate(event: MainEvent) -> DateComponents {
        NSLog("🌞 same day")
        var comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: DateEventFormatter.updateYear(event.eventDate))
        
        let timeComps = Calendar.current.dateComponents([.hour, .minute, .second], from: AppConfiguration.notificationTime)
        
        comps.hour = timeComps.hour
        comps.minute = timeComps.minute
        comps.second = timeComps.second
        
        NSLog("next notification of \(event.title) on : \(comps)")
        return comps
    }
    
    static func sameDayRequest(event: MainEvent) -> UNNotificationRequest{
        assert(event.notificationSameDayId != nil)
        // set up content
        let content = prepareContent(event: event)
        
        // set up date
        let dateComponents = prepareDaySameDate(event: event)
        
        // set up trigger
        let trigger = self.prepareTrigger(event: event, dateComponents: dateComponents)
        
        let request = UNNotificationRequest(identifier: event.notificationSameDayId!, content: content, trigger: trigger)
        
        return request
    }
    
    // MARK: - DAYS BEFORE EVENT 🌆
    private static func prepareDaysBeforeDate(event: MainEvent) -> DateComponents? {
        NSLog("🌞 days before: \(AppConfiguration.notificateBeforeInDays?.rawValue ?? "none")")
        let currentComps = prepareDaySameDate(event: event)
        guard let currentDateFromComps = Calendar.current.date(from: currentComps) else {
            NSLog("🤖 error while subtract day - retun current nil")
            return nil
        }
        let dayComp = DateComponents(day: AppConfiguration.notificateBeforeInDays?.getDays())
        
        let date = Calendar.current.date(byAdding: dayComp, to: currentDateFromComps)
        
        let subtracktedComps = Calendar.current.dateComponents([.year, .month, .day,.hour,.minute,.second], from: date!)
        
        NSLog("next days before notification of \(event.title) on : \(subtracktedComps)")
        
        return subtracktedComps
    }
    
    static func dayBeforeRequest(event: MainEvent) -> UNNotificationRequest?{
        assert(event.notificationDaysBeforeId != nil)
        // set up content
        let content = prepareContentDaysBefore(event: event)
        
        // set up date
        guard let dateComponents = prepareDaysBeforeDate(event: event) else {
            return nil
        }
        
        // set up trigger
        let trigger = self.prepareTrigger(event: event, dateComponents: dateComponents)
        
        let request = UNNotificationRequest(identifier: event.notificationDaysBeforeId!, content: content, trigger: trigger)
        
        return request
    }
    
    // MARK: - EVENT TIME ⌛️
    
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
    
    // MARK: - GENERAL 🍖
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
        let df = DateEventFormatter(date: event.eventDate)
        
        switch event.eventType {
        case .birthday:
            let content = UNMutableNotificationContent()
            content.title = "🎂" + event.title
            content.body = df.yearsTurnsInDays()
            return content
            
        case .anniversary:
            let content = UNMutableNotificationContent()
            content.title = "💗" + event.title
            content.body = df.yearsTurnsInDays()
            return content
            
        case .simpleEvent:
            let content = UNMutableNotificationContent()
            content.title = "✨" + event.title
            return content
            
        }
        
    }
    
    private static func prepareContentDaysBefore(event: MainEvent) -> UNMutableNotificationContent{
        let df = DateEventFormatter(date: event.eventDate)
        let inTime = df.yearsTurnsInDays()
        NSLog("⌚️ notify in time: \(inTime)")
        
        switch event.eventType {
        case .birthday:
            let content = UNMutableNotificationContent()
            content.title = "🎂" + event.title
            content.body = inTime
            return content
            
        case .anniversary:
            let content = UNMutableNotificationContent()
            content.title = "💗" + event.title
            content.body = inTime
            return content
            
        case .simpleEvent:
            let content = UNMutableNotificationContent()
            content.title = "✨" + event.title
            return content
            
        }
        
    }
    
    // MARK: - DELETING NOTIFICATION ⏰🧨
    static func cancelAllNotifications(){
        let notificationCenter = UNUserNotificationCenter.current()
        NSLog("🧼 clear all pending notifications")
        
        if #available(iOS 17.0, *) {
            notificationCenter.removeAllPendingNotificationRequests()
        } else {
            notificationCenter.getPendingNotificationRequests(completionHandler: {notifications in
                let ids = notifications.map({$0.identifier})
                NSLog("notifications: \(ids)")
                notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
            })
            notificationCenter.removeAllPendingNotificationRequests()
        }
    }
    
    static func cancelNotifications(ids: [String]){
        NSLog("🧨 cancel notifications for ids: \(ids)")
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeDeliveredNotifications(withIdentifiers: ids)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
    }
}



