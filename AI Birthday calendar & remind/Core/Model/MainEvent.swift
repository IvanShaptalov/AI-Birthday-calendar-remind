//
//  MainEvent.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 20.02.2024.
//

import Foundation

/// Main event: birthday, simple event or anniversary, image path for object
/// title, and date, and notification date before - example: 1 day before, 1 week before
protocol MainEventProtocol {
    var id: String {get set}
    var eventDate: Date {get set}
    var eventType: EventTypeEnum {get set}
    /// name or simple event text
    var title: String {get set}
    /// congratulation
    var congratulation: String?{get set}
    
    var imagePath: String? {get set}
    
    var notificationSameDayId: String? {get set}
    var notificationDaysBeforeId: String? {get set}
    var notificationEventId: String? {get set}
    
    func getImageSystemName(eventType rule: EventTypeEnum) -> String
}


class MainEvent: MainEventProtocol, Codable{
    var notificationSameDayId: String?
    
    var notificationDaysBeforeId: String?
    
    var notificationEventId: String?
    
    func getNotificationIds() -> [String] {
        var ntf: [String?] = [notificationEventId, notificationSameDayId, notificationDaysBeforeId]
        ntf.removeAll(where: {$0 == nil})
        return ntf as! [String]
    }
    
    // MARK: - Set up Notifications
    func setUpNotificationIds(){
        if self.eventType == .simpleEvent {
            NSLog("⚙️ set up notify rules as event 📅")
            self.notificationEventId = NotifyCategory.Event.rawValue + UUID().uuidString
            self.notificationSameDayId = nil
            self.notificationDaysBeforeId = nil
        } else {
            NSLog("⚙️ set up notify rules: sameday: \(AppConfiguration.isNotificateSameDay)| day before: \(AppConfiguration.isNotificateDaysBefore)")
            if AppConfiguration.isNotificateDaysBefore {
                self.notificationDaysBeforeId = NotifyCategory.DaysBefore.rawValue + UUID().uuidString
            } else {
                self.notificationDaysBeforeId = nil
            }
            
            if AppConfiguration.isNotificateSameDay {
                self.notificationSameDayId = NotifyCategory.SameDay.rawValue + UUID().uuidString
            } else {
                self.notificationSameDayId = nil
            }
        }
    }
    
    var id: String
    var congratulation: String?
    var eventDate: Date
    var eventType: EventTypeEnum {
        didSet {
            self.imagePath = getImageSystemName(eventType: eventType)
            if eventType == .simpleEvent {
                self.notificationEventId = UUID().uuidString
            }
        }
    }
    var title: String
    var imagePath: String?
    
    // MARK: - Set up image
    func getImageSystemName(eventType rule: EventTypeEnum) -> String {
        switch rule {
        case .birthday:
            return "gift"
        case .anniversary:
            return "suit.heart.fill"
        case .simpleEvent:
            return "sparkles"
        }
    }

    init(eventDate: Date, eventType :EventTypeEnum, title: String, id: String, congratulation: String? = nil){
        self.id = id
        self.eventDate = eventDate
        self.eventType = eventType
        self.title = title
        self.congratulation = congratulation
        self.setUpNotificationIds()
        self.imagePath = getImageSystemName(eventType: eventType)
    }
    
    init(eventType: EventTypeEnum) {
        self.id = UUID().uuidString
        self.eventDate = .now
        self.title = ""
        self.eventType = eventType
        self.imagePath = getImageSystemName(eventType: eventType)
        self.congratulation = nil
        self.setUpNotificationIds()
    }
    
    // MARK: - JSON
    enum ConfigKeys: String, CodingKey {
        case id
        case congratulation
        case eventDate
        case eventType
        case title
        case imagePath
        case notificationSameDayId
        case notificationEventId
        case notificationDaysBeforeId
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.id = try values.decodeIfPresent(String.self, forKey: .id)!
        self.congratulation = try values.decodeIfPresent(String.self, forKey: .congratulation)
        self.eventDate = try values.decodeIfPresent(Date.self, forKey: .eventDate)!
        self.eventType = try values.decodeIfPresent(EventTypeEnum.self, forKey: .eventType)!
        self.title = try values.decodeIfPresent(String.self, forKey: .title)!
        self.notificationSameDayId = try values.decodeIfPresent(String.self, forKey: .notificationSameDayId)
        self.notificationEventId = try values.decodeIfPresent(String.self, forKey: .notificationEventId)
        self.notificationDaysBeforeId = try values.decodeIfPresent(String.self, forKey: .notificationDaysBeforeId)
        self.imagePath = try values.decodeIfPresent(String.self, forKey: .imagePath)
    }
}

// MARK: - HASH
extension MainEvent: Equatable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.congratulation)
        hasher.combine(self.eventDate)
        hasher.combine(self.title)
        hasher.combine(self.imagePath)
        hasher.combine(self.eventType)
        hasher.combine(self.notificationSameDayId)
    }
    
    static func == (lhs: MainEvent, rhs: MainEvent) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}


enum NotifyCategory: String {
    case Event = "eventNotify"
    case DaysBefore = "dayBeforeNotify"
    case SameDay = "sameDayNotify"
}
