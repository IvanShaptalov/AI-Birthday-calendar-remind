//
//  Enumerations.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 19.02.2024.
//

import Foundation

// MARK: - Events
enum EventTypeEnum: String {
    case
    birthday = "Birthday",
    anniversary = "Anniversary",
    simpleEvent = "event"
}


class NotificateBeforeClass{
    var rule: NotificateBeforeEnum
    private var dayCount: Int
    
    func getDayCount() -> Int {
        return self.dayCount
    }
    
    init(rule: NotificateBeforeEnum) {
        self.rule = rule
        switch rule {
        case .oneDayBefore:
            self.dayCount = 1
        case .twoDaysBefore:
            self.dayCount = 2
        case .threeDaysBefore:
            self.dayCount = 3
        case .fourDaysBefore:
            self.dayCount = 4
        case .fiveDaysBefore:
            self.dayCount = 5
        case .sevenDaysBefore:
            self.dayCount = 7
        }
    }
}

// MARK: - Day before notification
enum NotificateBeforeEnum: String{
    case
    oneDayBefore = "1 day",
    twoDaysBefore = "2 days",
    threeDaysBefore = "3 days",
    fourDaysBefore = "4 days",
    fiveDaysBefore = "5 days",
    sevenDaysBefore = "1 week"
}


// MARK: - Wish generator
class WishGeneratorClass{
    var rule: WishGeneratorEnum
    var title: String
    var description: String
    var backgroundImagePath: String
    
    init(rule: WishGeneratorEnum) {
        self.rule = rule
        switch rule {
      
        case .birthday:
            self.title = "1"
            self.description = "1"
            self.backgroundImagePath = "1"
        case .holidays:
            self.title = "1"
            self.description = "1"
            self.backgroundImagePath = "1"
        case .anniversaries:
            self.title = "1"
            self.description = "1"
            self.backgroundImagePath = "1"
        case .wordsOfLove:
            self.title = "1"
            self.description = "1"
            self.backgroundImagePath = "1"
        case .toasts:
            self.title = "1"
            self.description = "1"
            self.backgroundImagePath = "1"
        case .inspirations:
            self.title = "1"
            self.description = "1"
            self.backgroundImagePath = "1"
        }
    }
}


enum WishGeneratorEnum {
    case
    birthday,
    holidays,
    anniversaries,
    wordsOfLove,
    toasts,
    inspirations
}
