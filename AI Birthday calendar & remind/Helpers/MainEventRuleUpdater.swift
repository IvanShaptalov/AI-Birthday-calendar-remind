//
//  MainEventRuleUpdater.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 28.02.2024.
//

import Foundation


class MainEventRuleUpdater {
    static func updateRules(){
        NSLog("📜 rule updating for all events")
        let start = DispatchTime.now() // <<<<<<<<<< Start time

        var mainEvents = MainEventStorage.load()
        mainEvents.sort{DateEventFormatter.yearToCurrentInEvent($0)  < DateEventFormatter.yearToCurrentInEvent($1)}
        // reschedule notifications
        mainEvents.forEach({$0.setUpNotificationIds()})

        NotificationServiceProvider.cancelAllNotifications()
        for (index, event) in mainEvents.enumerated() {
            NSLog("✨ event to notify: \(event.title)")
            if isNeedToNotify(index: index){
                NotificationServiceProvider.scheduleEvent(event: event, notifDisabled: nil)
            }
        }
        MainEventStorage.save(mainEvents)
        
        let end = DispatchTime.now()   // <<<<<<<<<<   end time
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
            let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

        NSLog("📜 rule for \(mainEvents.count) events  updated in \(timeInterval) seconds")
    }
    
    
    /// set notification to first free events if is not premium account
    private static func isNeedToNotify(index i: Int) -> Bool {
        if MonetizationConfiguration.isPremiumAccount {
            NSLog("⏰ is premium account - need to notify")
            return true
        } else {
            NSLog("⏰ is not premium, i = \(i), free events: \(MonetizationConfiguration.freeEventRecords) notify next? : \(i < MonetizationConfiguration.freeEventRecords)")
            return i < MonetizationConfiguration.freeEventRecords
        }
    }
}
