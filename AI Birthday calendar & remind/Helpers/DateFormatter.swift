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
    
    /// returns true if expired
    static func isExpired(_ date: Date) -> Bool{
        let dateComponents = DateFormatterWrapper.dateDistance(from: DateFormatterWrapper.startOfDay(.now), to: DateFormatterWrapper.startOfDay(date), components: [.day])
        
        guard let days = dateComponents.day else {
            return true
        }
        
        return days < 0
    }
    
    static func dateDistance(from: Date, to: Date, components: Set<Calendar.Component>) -> DateComponents{
        let calendar = Calendar.current
        let components = calendar.dateComponents(components, from: from, to: to)
        return components
    }
    
    static func startOfDay(_ date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    static func yearToCurrent(_ date: Date) -> Date {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: .now)
        var comps = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        comps.setValue(year, for: .year)
        let updatedDate = calendar.date(from: comps)
        NSLog("updatedDate: \(updatedDate)")
        return updatedDate ?? date
    }
    
    func hourAndMinute() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter.string(from: date)
    }
    
    func timeLeftInDays() -> String {
        let calendar = Calendar.current

        let currentDate = calendar.startOfDay(for: Date())
        let startOfDay = calendar.startOfDay(for: self.date)
        let components = DateFormatterWrapper.dateDistance(from: currentDate, to: startOfDay, components: [.day])
        
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
