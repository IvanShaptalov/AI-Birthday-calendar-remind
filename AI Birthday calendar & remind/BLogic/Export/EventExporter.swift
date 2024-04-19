//
//  EventExporter.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 19.04.2024.
//

import Foundation
import UIKit

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

        let url = FileSharing.getDocumentsDirectory(fileName: "birthdays.csv")
                
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
        
        let url = FileSharing.getDocumentsDirectory(fileName: "birthdays.txt")
                
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
    func export(){
        
    }
}

// MARK: - Reminder
class ReminderEventExporter: EventExporter {
    func export(){
        
    }
}


