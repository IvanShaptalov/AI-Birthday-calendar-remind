//
//  Enumerations.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 19.02.2024.
//

import Foundation

// MARK: - Events
enum EventTypeEnum: String, Codable {
    case
    birthday = "Birthday",
    anniversary = "Anniversary",
    simpleEvent = "Event"
}


class NotificateBeforeClass: Codable{
    var rule: NotificateBeforeEnum
    var dayCount: Int
    
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
    
    enum ConfigKeys: String, CodingKey {
        case rule
        case dayCount
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.rule = try values.decodeIfPresent(NotificateBeforeEnum.self, forKey: .rule)!
        self.dayCount = try values.decodeIfPresent(Int.self, forKey: .dayCount)!
    }
}

// MARK: - Day before notification
enum NotificateBeforeEnum: String, Codable{
    case
    oneDayBefore = "1 day",
    twoDaysBefore = "2 days",
    threeDaysBefore = "3 days",
    fourDaysBefore = "4 days",
    fiveDaysBefore = "5 days",
    sevenDaysBefore = "1 week"
    
    static let allValues = [oneDayBefore, twoDaysBefore, threeDaysBefore, fourDaysBefore, fiveDaysBefore, sevenDaysBefore]
    
    func getDays() -> Int{
        switch self {
            
        case .oneDayBefore:
            return -1
        case .twoDaysBefore:
            return -2
            
        case .threeDaysBefore:
            return -3
            
        case .fourDaysBefore:
            return -4
            
        case .fiveDaysBefore:
            return -5
            
        case .sevenDaysBefore:
            return -7
            
        }
    }
}


// MARK: - Wish type
enum WishType: String {
    case
    bday = "Birthday",
    anniversary = "Anniversary",
    holiday = "Holiday",
    
    newYear = "New Year",
    valentinesDay = "Valentine's Day",
    christmas = "Christmas",
    graduation = "Graduation",
    
    independenceDay = "Independence Day",
    
    toasts = "Toasts"
    
    static func allValues() -> [WishType] {
        return [
            .bday,
            .anniversary,
            .holiday,
            .toasts,
            .independenceDay,
            .newYear,
            .christmas,
            
                .valentinesDay,
            .graduation
            
        ]
    }
    
    static func allValuesRaw() -> [String] {
        return allValues().map { $0.rawValue }
    }
    
    func getImageSystemName() -> String {
        switch self {
        case .bday:
            return "gift.fill"
        case .anniversary:
            return "heart.fill"
        case .holiday:
            return "star.fill"
        case .graduation:
            return "graduationcap.fill"
        case .newYear:
            return "sparkles"
        case .valentinesDay:
            return "heart.circle.fill"
        case .christmas:
            return "snowflake"
        case .independenceDay:
            return "flag.fill"
        case .toasts:
            return "wineglass.fill"
        }
    }
}




// MARK: - MessageStyle
enum MessageStyle: String {
    case
    casual = "casual",
    formal = "formal",
    
    romantic = "romantic",
    poetic = "poetic",
    
    humorous = "humorous",
    
    philosophical = "philosophical",
    inspirational = "inspirational",
    professional = "professional"
    
    static func allValues() -> [MessageStyle] {
        return [
            .casual,
            .formal,
            .romantic,
            .poetic,
            .humorous,
            .philosophical,
            .inspirational,
            .professional
        ]
    }
    
    static func allValuesRaw() -> [String] {
        return allValues().map { $0.rawValue }
    }
}

// MARK: - WhoWish
enum WhoWish: String {
    case
    friend = "Friend",
    mother = "Mother",
    father = "Father",
    sibling = "Sibling",
    partner = "Partner",
    grandparent = "Grandparent",
    cousin = "Cousin",
    aunt = "Aunt",
    uncle = "Uncle",
    niece = "Niece",
    nephew = "Nephew",
    inlaw = "In-law",
    mentor = "Mentor",
    colleague = "Colleague",
    neighbor = "Neighbor",
    teacher = "Teacher",
    student = "Student",
    coach = "Coach",
    boss = "Boss",
    employee = "Employee",
    doctor = "Doctor",
    nurse = "Nurse",
    therapist = "Therapist",
    landlord = "Landlord",
    girlfriend = "Girlfriend",
    boyfriend = "Boyfriend",
    wife = "Wife",
    husband = "Husband",
    son = "Son",
    daughter = "Daughter",
    grandson = "Grandson",
    granddaughter = "Granddaughter"
    
    static func allValuesAnniversary() -> [WhoWish]  {
        // Placeholder for anniversary-related relationships
        return [.wife, .husband, .girlfriend, .boyfriend]
    }
}

