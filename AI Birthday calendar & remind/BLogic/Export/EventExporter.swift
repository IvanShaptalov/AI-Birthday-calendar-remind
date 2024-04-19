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
    
    func export(){
        
    }
    
    init(formattedText: String, events: [MainEvent]) {
        self.formattedText = formattedText
        self.events = events
    }
}

class TableEventExporter: EventExporter {
    
}

class ClipBoardEventExporter: EventExporter {
    override func export() {
        UIPasteboard.general.string = self.formattedText
    }
}

class TextFileEventExporter: EventExporter {
    
}

class CalendarEventExporter: EventExporter {
    
}

class ReminderExporter: EventExporter {
    
}


