//
//  DateFormatter.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 22.02.2024.
//

import Foundation


class DateEventFormatter {
    var date: Date
    
    init(date: Date) {
        self.date = date
    }
    
    
        
    static func dateDistance(from: Date, to: Date, components: Set<Calendar.Component>) -> DateComponents{
        let calendar = Calendar.current
        let components = calendar.dateComponents(components, from: from, to: to)
        return components
    }
    
    /// set date hours to AppConfiguration.notificationTime
    static func notificateTimeToRules(eventDate: Date) -> Date?{
        let currentComps = DateHoursPreparer.prepareDaySameDate(eventDate: eventDate)
    
        let date = Calendar.current.date(from: currentComps)
        
        return date
    }
   
    
    /// update year to current in birthdays and anniversary
    static func yearToCurrentInEvent(_ event: MainEvent) -> Date {
        if event.eventType == .simpleEvent {
            return event.eventDate
        }
        return updateYear(event.eventDate)
    }
    
    static func updateYear(_ dateParam: Date) -> Date {
        
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: dateParam)
        var year = calendar.component(.year, from: .now)
        var comps = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        comps.setValue(year, for: .year)
        
        guard var updatedDate = calendar.date(from: comps) else {
            return date
        }
        // check that date is not expired else add year
        let components = DateEventFormatter.dateDistance(from: .now, to: updatedDate, components: [.day])
        
        guard let days = components.day else {
            return date
        }
        
        // add years to updated date
        if days < 0 {
            let addYears = ((days * -1)+365) / 365
            
            year += addYears
            NSLog("days old: \(days) new year: \(year)")
            
            comps.setValue(year, for: .year)
            updatedDate = calendar.date(from: comps) ?? updatedDate


        }
        
        return updatedDate
    }
    
    // MARK: - TEXT DATES
    func timeLeftInDaysForEvent() -> String {
        let calendar = Calendar.current

        let currentDate = calendar.startOfDay(for: Date())
        let startOfDay = calendar.startOfDay(for: self.date)
        let components = DateEventFormatter.dateDistance(from: currentDate, to: startOfDay, components: [.day])
        
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
    
    func yearsTurns() -> Int {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let thisYearBirthdayDate = calendar.startOfDay(for: DateEventFormatter.updateYear(self.date))
        _ = DateEventFormatter.dateDistance(from: currentDate, to: thisYearBirthdayDate, components: [.day])
        
        let yearTurns = Calendar.current.component(.year, from: thisYearBirthdayDate)-Calendar.current.component(.year, from: self.date)
        return yearTurns
    }
    
    func yearsTurnsInDays() -> String {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let thisYearBirthdayDate = calendar.startOfDay(for: DateEventFormatter.updateYear(self.date))
        let components = DateEventFormatter.dateDistance(from: currentDate, to: thisYearBirthdayDate, components: [.day])
        
        let yearTurns = Calendar.current.component(.year, from: thisYearBirthdayDate)-Calendar.current.component(.year, from: self.date)

        
        guard let days = components.day else {
            return "Date has passed"
        }
        
        if days > 0 {
            if days == 1{
                return "turns \(yearTurns) in \(days) day"
            }
            return "turns \(yearTurns) in \(days) days"
            
        }
        
        return "turns \(yearTurns) today"
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
    
    func hourAndMinute() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        return dateFormatter.string(from: date)
    }
    
}


class DateHoursPreparer{
    static func prepareDaySameDate(eventDate: Date) -> DateComponents {
        var comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: DateEventFormatter.updateYear(eventDate))
        
        let timeComps = Calendar.current.dateComponents([.hour, .minute, .second], from: AppConfiguration.notificationTime)
        
        comps.hour = timeComps.hour
        comps.minute = timeComps.minute
        comps.second = timeComps.second
        
        return comps
    }
}
