//
//  EventExporter.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 19.04.2024.
//

import Foundation
import UIKit
import EventKit

// MARK: - Base Exporter
class EventExporter {
    var formattedText: String
    var events: [MainEvent]
    
    
    init(formattedText: String, events: [MainEvent]) {
        self.formattedText = formattedText
        self.events = events
    }
}

// MARK: - Table
class TableEventExporter: EventExporter {
    func export(isTitleFirst: Bool, formatter: DateFormatter) -> URL? {
        // Define your data
        var headers = ["Date", "Name"]
        
        if isTitleFirst {
            headers = headers.reversed()
        }
        
        var rows: [[String]] = []
        
        events.sort(by: {$0.eventDate > $1.eventDate})
        
        for event in self.events {
            if isTitleFirst {
                rows.append([event.title, formatter.string(from: event.eventDate)])
            } else {
                rows.append([formatter.string(from: event.eventDate), event.title])
            }
        }
        
        
        // Prepare CSV content
        var csvString = headers.joined(separator: ",") + "\n"
        for row in rows {
            let rowString = row.map { $0.replacingOccurrences(of: ",", with: "") }.joined(separator: ",")
            csvString.append(rowString + "\n")
        }
        
        let url = FileSharing.getDocumentsDirectory(fileName: "birthdays in table.csv")
        
        do {
            try csvString.write(to: url!, atomically: true, encoding: .utf8)
            print("CSV file created successfully.")
        } catch {
            print("Error writing CSV file: \(error)")
        }
        
        return url
    }
}

// MARK: - ClipBoard
class ClipBoardEventExporter: EventExporter {
    func export() {
        UIPasteboard.general.string = self.formattedText
    }
}

// MARK: - Text
class TextFileEventExporter: EventExporter {
    func export() -> URL? {
        let data = Data(self.formattedText.utf8)
        
        let url = FileSharing.getDocumentsDirectory(fileName: "birthdays in text.txt")
        
        do {
            try data.write(to: url!, options: [.atomic, .completeFileProtection])
            let input = try String(contentsOf: url!)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
        
        return url
    }
}

// MARK: - Calendar
class CalendarEventExporter: EventExporter {
    func prepareDate(date: Date) -> Date {
        return .now
    }
    
    func export(statusCallback: @escaping(String, Bool) -> Void){
        NSLog("📆 export calendars")
        
        let eventStore = EKEventStore()
        // check access to reminders
        
        var cEvents: [EKEvent] = []
        // event saving to reminder
        for event in self.events {
            let calendarEvent:EKEvent = EKEvent(eventStore: eventStore)
            calendarEvent.title = event.title
            
            // to AppConfiguration.notificationTime
            let startDateWithoutDateRule = DateEventFormatter.yearToCurrentInEvent(event)
            guard let startDate = DateEventFormatter.notificateTimeToRules(eventDate: startDateWithoutDateRule) else {
                continue
            }
            
            calendarEvent.startDate = event.eventType == .simpleEvent ? event.eventDate : startDate
            
            calendarEvent.endDate = calendarEvent.startDate.addingTimeInterval(60*60)  // 1 hour
            
            
            calendarEvent.calendar = eventStore.defaultCalendarForNewEvents
            
            cEvents.append(calendarEvent)
            
        }
        
        do {
            try cEvents.forEach({try eventStore.save($0, span: EKSpan.futureEvents)})
        } catch let error as NSError{
            NSLog("error while export to calendars: \(error.localizedDescription)")
            statusCallback("Cannot export birthdays to calendar", false)
            return
        }
        statusCallback("Birthdays exported", true)
    }
    
}

// MARK: - Reminder
class ReminderEventExporter: EventExporter {
    
    func export(statusCallback: @escaping(String, Bool) -> Void){
        NSLog("⏰ export reminders")
        
        let eventStore = EKEventStore()
        // check access to reminders
        
        var reminders: [EKReminder] = []
        // event saving to reminder
        for event in self.events {
            let reminder:EKReminder = EKReminder(eventStore: eventStore)
            reminder.title = event.title
            reminder.priority = 2
            
            // update year to current in birthdays and anniversary
            // to AppConfiguration.notificationTime
            let alarmTimeWithoutTimeRule = DateEventFormatter.yearToCurrentInEvent(event)
            guard let alarmTime = DateEventFormatter.notificateTimeToRules(eventDate: alarmTimeWithoutTimeRule) else {
                continue
            }
            
            // if simple event, keep default date
            let alarm = EKAlarm(absoluteDate: event.eventType == .simpleEvent ? event.eventDate : alarmTime)
            reminder.addAlarm(alarm)
            
            reminder.calendar = eventStore.defaultCalendarForNewReminders()
            
            reminders.append(reminder)
            
        }
        
        do {
            try reminders.forEach({try eventStore.save($0, commit: true)})
        } catch {
            statusCallback("Cannot export events to reminders", false)
            return
        }
        statusCallback("Reminders exported", true)
    }
    
}


