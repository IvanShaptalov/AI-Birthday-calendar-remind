//
//  ExpiredEventUpdater.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 27.02.2024.
//

import Foundation


class ExpiredEventUpdater {
    static func refreshExpired(_ eventList: [MainEvent]) -> [MainEvent] {
        // if list fresh just return
        if !eventList.contains(where: {DateFormatterWrapper.isExpired($0.eventDate) == true}){
            NSLog("List fresh 🥥")
            return eventList
        }
        NSLog("List expired 🤢")
        var newEventList: [MainEvent] = []
        for event in eventList {
            
            // date expired
            if DateFormatterWrapper.isExpired(event.eventDate) {
                NSLog("date expired for")
                NSLog("\(event.eventType)")
                // if simple event - just delete
                if event.eventType == .simpleEvent {
                    continue
                }
                // otherwise add one year
                DateFormatterWrapper.updateYearToFresh(&event.eventDate)
                newEventList.append(event)
            } else {
                newEventList.append(event)
            }
        }
        
        return newEventList
    }
    
    
}
