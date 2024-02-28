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
        mainEvents.sort{DateFormatterWrapper.yearToCurrentInEvent($0)  < DateFormatterWrapper.yearToCurrentInEvent($1)}
        // reschedule notifications
        mainEvents.forEach({$0.setUpNotificationIds()})

        NotificationServiceProvider.cancelAllNotifications()
        mainEvents.forEach({NotificationServiceProvider.scheduleEvent(event: $0)})
        MainEventStorage.save(mainEvents)
        
        let end = DispatchTime.now()   // <<<<<<<<<<   end time
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
            let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests

        NSLog("📜 rule for \(mainEvents.count) events  updated in \(timeInterval) seconds")
    }
}
