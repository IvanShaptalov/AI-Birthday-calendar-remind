//
//  DateFormatter.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 22.02.2024.
//

import Foundation


class DateFormatterWrapper {
    var date: Date
    
    init(date: Date) {
        self.date = date
    }
    
    func timeLeftInDays() -> String {
        let calendar = Calendar.current

        let currentDate = calendar.startOfDay(for: Date())
        let startOfDay = calendar.startOfDay(for: self.date)
        let components = calendar.dateComponents([.day], from: currentDate, to: startOfDay)
        guard let days = components.day else {
            return "Date has passed"
        }
        
        if days > 0 {
            if days == 1{
                return "\(days) day left"
            }
            return "\(days) days left"
            
        } else if days == 0 {
            return "Today"
        } else {
            return "Date has passed"
        }
    }
    
    func dayOfWeekCalendarFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
    
    func monthAndDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: date)
    }
}
