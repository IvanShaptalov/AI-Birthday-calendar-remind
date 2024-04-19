//
//  EventExporter.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 19.04.2024.
//

import Foundation
import UIKit


class EventExporter {
    var formattedText: String
    var events: [MainEvent]
    
    
    init(formattedText: String, events: [MainEvent]) {
        self.formattedText = formattedText
        self.events = events
    }
}

class TableEventExporter: EventExporter {
    
}

class ClipBoardEventExporter: EventExporter {
    func export() {
        UIPasteboard.general.string = self.formattedText
    }
}

class TextFileEventExporter: EventExporter {
    func export() -> URL? {
        let data = Data(self.formattedText.utf8)
        if #available(iOS 16.0, *) {
            let url = URL.documentsDirectory.appending(path: "\(Date.now.timeIntervalSince1970)events.txt")
            
            do {
                try data.write(to: url, options: [.atomic, .completeFileProtection])
                let input = try String(contentsOf: url)
                print(input)
            } catch {
                print(error.localizedDescription)
            }
            
            return url
        } else {
            // Fallback on earlier versions
        }
        
        return nil
    }
}

class CalendarEventExporter: EventExporter {
    
}

class ReminderExporter: EventExporter {
    
}


