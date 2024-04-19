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
    func export() {
        
    }
}

class ClipBoardEventExporter: EventExporter {
    func export() {
        UIPasteboard.general.string = self.formattedText
    }
}

class TextFileEventExporter: EventExporter {
    func export() -> URL? {
        let data = Data(self.formattedText.utf8)
        
        var url: URL?
        
        if #available(iOS 16.0, *) {
            url = URL.documentsDirectory.appending(path: "\(Date.now.timeIntervalSince1970)events.txt")
            
            
        } else {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            url = paths.first
            
            url = url?.appendingPathComponent("\(Date.now.timeIntervalSince1970)events.txt", isDirectory: false)
        }
        
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

class CalendarEventExporter: EventExporter {
    
}

class ReminderExporter: EventExporter {
    
}


