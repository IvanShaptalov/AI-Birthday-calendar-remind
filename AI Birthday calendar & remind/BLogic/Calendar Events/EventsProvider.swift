//
//  CalendarEventsProvider.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 13.03.2024.
//

import Foundation
import EventKit


class EventsProvider {
    static func importData() -> [MainEvent]{
        NSLog("🚛 📆 import events")
        var mainEvents : [MainEvent] = []
        
        let store = EKEventStore()
        
        let calendars = store.calendars(for: .event)
        
        for calendar in calendars {
            if ["Calendar", "Birthdays"].contains(calendar.title){
                let oneMonthAgo = Date(timeIntervalSinceNow: -30*24*3600)
                let twelveMonthAfter = Date(timeIntervalSinceNow: 30*24*3600*12)
                let predicate =  store.predicateForEvents(withStart: oneMonthAgo, end: twelveMonthAfter, calendars: [calendar])
                
                let events = store.events(matching: predicate)
                
                for event in events {
                    mainEvents.append(.init(eventDate: event.startDate, eventType: .birthday, title: event.title, id: event.eventIdentifier))
                }
            }
            
        }
        return mainEvents
    }
}
