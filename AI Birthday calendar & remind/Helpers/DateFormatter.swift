//
//  DateFormatter.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 22.02.2024.
//

import Foundation


class DateFormatter {
    var date: Date
    
    init(date: Date) {
        self.date = date
    }
    
    func timeLeftInDays() -> String {
        return "22 day left"
    }
    
    func dayOfWeekCalendarFormat() -> String {
        return "wed".uppercased()
    }
    
    func monthAndDay() -> String {
        return "Apr 17"
    }
}
