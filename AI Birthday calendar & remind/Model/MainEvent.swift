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
    var notificationBefore: NotificateBeforeClass {get set}

    
    func getImagePath(eventType rule: EventTypeEnum) -> String
}


struct MainEvent: MainEventProtocol{
    var id: String
    var congratulation: String?
    var eventDate: Date
    var eventType: EventTypeEnum
    var title: String
    var imagePath: String?
    var notificationBefore: NotificateBeforeClass
    
    func getImagePath(eventType rule: EventTypeEnum) -> String {
        switch rule {
        case .birthday:
            return "birthday image"
        case .anniversary:
            return "anniversary image"
        case .simpleEvent:
            return "simple event"
        }
    }

    init(eventDate: Date, eventType :EventTypeEnum, title: String, rule: NotificateBeforeEnum, id: String, congratulation: String? = nil) {
        self.id = id
        self.eventDate = eventDate
        self.eventType = eventType
        self.title = title
        self.notificationBefore = NotificateBeforeClass(rule: rule)
        self.imagePath = getImagePath(eventType: eventType)
        self.congratulation = congratulation
    }
}


extension MainEvent: Codable {
    enum ConfigKeys: String, CodingKey {
        case id
        case congratulation
        case eventDate
        case eventType
        case title
        case imagePath
        case notificationBefore
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.id = try values.decodeIfPresent(String.self, forKey: .id)!
        self.congratulation = try values.decodeIfPresent(String.self, forKey: .congratulation)
        self.eventDate = try values.decodeIfPresent(Date.self, forKey: .eventDate)!
        self.eventType = try values.decodeIfPresent(EventTypeEnum.self, forKey: .eventType)!
        self.title = try values.decodeIfPresent(String.self, forKey: .title)!
        self.imagePath = try values.decodeIfPresent(String.self, forKey: .imagePath)!
        self.notificationBefore = try values.decodeIfPresent(NotificateBeforeClass.self, forKey: .notificationBefore)!
    }
}


extension MainEvent: Equatable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.congratulation)
        hasher.combine(self.eventDate)
        hasher.combine(self.title)
        hasher.combine(self.imagePath)
        hasher.combine(self.eventType)
    }
    
    static func == (lhs: MainEvent, rhs: MainEvent) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
