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
    
    graduation = "Graduation",
    newYear = "New Year",
    valentinesDay = "Valentine's Day",
    christmas = "Christmas",
    easter = "Easter",
    
    mothersDay = "Mother's Day",
    fathersDay = "Father's Day",
    
    thanksgiving = "Thanksgiving",
    
    halloween = "Halloween",
    
    independenceDay = "Independence Day",
    
    toasts = "Toasts"
    
    static func allValues() -> [WishType] {
        return [
            .bday,
            .anniversary,
            .holiday,
            .graduation,
            .newYear,
            .valentinesDay,
            .christmas,
            .easter,
            .mothersDay,
            .fathersDay,
            .thanksgiving,
            .halloween,
            .independenceDay,
            .toasts
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
        case .easter:
            return "hare.fill"
        case .mothersDay:
            return "person.fill"
        case .fathersDay:
            return "person.2.fill"
        case .thanksgiving:
            return "leaf.fill"
        case .halloween:
            return "moon.fill"
        case .independenceDay:
            return "flag.fill"
        case .toasts:
            return "sparkles"
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
    sarcastic = "sarcastic",
    
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
            .sarcastic,
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
    mother = "mother",
    father = "father",
    sibling = "sibling",
    partner = "partner",
    grandparent = "grandparent",
    cousin = "cousin",
    aunt = "aunt",
    uncle = "uncle",
    niece = "niece",
    nephew = "nephew",
    godparent = "godparent",
    godchild = "godchild",
    inlaw = "in-law",
    mentor = "mentor",
    colleague = "colleague",
    neighbor = "neighbor",
    teacher = "teacher",
    student = "student",
    coach = "coach",
    boss = "boss",
    employee = "employee",
    doctor = "doctor",
    nurse = "nurse",
    therapist = "therapist",
    landlord = "landlord",
    girlfriend = "girlfriend",
    boyfriend = "boyfriend",
    wife = "wife",
    husband = "husband",
    son = "son",
    daughter = "daughter",
    grandson = "grandson",
    granddaughter = "granddaughter"
    
    static func allValuesCloseFamily() -> [WhoWish]  {
        // Placeholder for close family members
        return [.mother, .father, .sibling, .partner, .son, .daughter, .grandson, .granddaughter]
    }
    
    static func allValuesCloseFamilyRaw() -> [String]  {
        // Placeholder for close family members
        return allValuesCloseFamily().map { $0.rawValue }
    }
    
    
    
    static func allValuesAnniversary() -> [WhoWish]  {
        // Placeholder for anniversary-related relationships
        return [.wife, .husband, .girlfriend, .boyfriend]
    }
    
    static func allValuesAnniversaryRaw() -> [String]  {
        // Placeholder for close family members
        return allValuesAnniversary().map { $0.rawValue }
    }
    
    static func allValuesFamily() -> [WhoWish]  {
        return [.mother, .father, .sibling, .partner, .grandparent, .cousin, .aunt, .uncle, .niece, .nephew, .godparent, .godchild, .inlaw]
    }
    
    static func allValuesFamilyRaw() -> [String]  {
        // Placeholder for close family members
        return allValuesFamily().map { $0.rawValue }
    }
    
    static func allValuesWork() -> [WhoWish] {
        return [.mentor, .colleague, .neighbor, .teacher, .student, .coach, .boss, .employee, .doctor, .nurse, .therapist, .landlord]
    }
    
    static func allValuesWorkRaw() -> [String]  {
        // Placeholder for close family members
        return allValuesWork().map { $0.rawValue }
    }
}

