//
//  RemindersProvider.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 13.03.2024.
//

import Foundation
import EventKit


class RemindersProvider {
    static func importData() -> [MainEvent]{
        NSLog("🚛 ⏰ import reminders")
        var mainEvents : [MainEvent] = []
        
        let store = EKEventStore()
        
        let calendars = store.calendars(for: .reminder)
        
        let predicate =  store.predicateForReminders(in: calendars)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        _ = store.fetchReminders(matching: predicate, completion: {reminders in
            if reminders != nil {
                for r in reminders! {
                    if !r.isCompleted {
                        let date = (r.dueDateComponents?.date ?? r.startDateComponents?.date ?? r.completionDate) ??  Date.now
                        mainEvents.append(.init(eventDate: date, eventType: .simpleEvent, title: r.title, id: r.calendarItemIdentifier))
                       
                    }
                }
            }
            semaphore.signal()
        })
        
        semaphore.wait()
        
        return mainEvents
    }
}
