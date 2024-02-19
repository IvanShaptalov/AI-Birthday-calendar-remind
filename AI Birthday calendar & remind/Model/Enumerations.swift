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
            self.title = "Birthdays"
            self.description = "Spark Joy with Personalized Greetings for Loved Ones and More!"
            self.backgroundImagePath = "1"
        case .holidays:
            self.title = "Holidays"
            self.description = "Create Memorable Holiday Greetings for Your Friends and Family"
            self.backgroundImagePath = "1"
        case .anniversaries:
            self.title = "Anniversaries"
            self.description = "Compose heartwarming messages to Celebrate Life`s Special Milestones!"
            self.backgroundImagePath = "1"
        case .wordsOfLove:
            self.title = "Words of Love"
            self.description = "Let your heart's song be heard through romantic messages"
            self.backgroundImagePath = "1"
        case .toasts:
            self.title = "Toasts"
            self.description = "Raise your glass with elegant toasts for every special occasion!"
            self.backgroundImagePath = "1"
        case .motivation:
            self.title = "Daily Motivation"
            self.description = "Ignite Each Day with a Spark of Motivation"
            self.backgroundImagePath = "1"
        }
    }
}


enum WishGeneratorEnum: String {
    case
    birthday = "birthday",
    holidays = "holidays",
    anniversaries = "anniversaries",
    wordsOfLove = "words of love",
    toasts = "toasts",
    motivation = "daily motivation"
}


// MARK: - Message style
enum ReceiverBirthdayEnum: String{
    case
    friend = "friend",
    husband = "husband",
    wife = "wife",
    mother = "mother",
    father = "father",
    girlfriend = "girlfriend",
    boyfriend = "boyfriend",
    brother = "brother",
    sister = "sister",
    cousin = "cousin",
    otherStyle = "other style"
}

// MARK: - Receiver

// MARK: - MessageStyle
enum MessageStyle: String{
    case
    casual = "casual",
    formal = "formal",
    humorous = "humorous",
    philosophical = "philosophical",
    poetic = "poetic",
    romantic = "romantic",
    inspirational = "inspirational"
}
