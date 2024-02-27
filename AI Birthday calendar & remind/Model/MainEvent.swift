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
    
    var notificationIds: [String] {get set}
    
    func getImageSystemName(eventType rule: EventTypeEnum) -> String
}


class MainEvent: MainEventProtocol, Codable{
    var notificationIds: [String]
    var id: String
    var congratulation: String?
    var eventDate: Date
    var eventType: EventTypeEnum {
        didSet {
            self.imagePath = getImageSystemName(eventType: eventType)
        }
    }
    var title: String
    var imagePath: String?
    
    func getImageSystemName(eventType rule: EventTypeEnum) -> String {
        switch rule {
        case .birthday:
            return "birthday.cake.fill"
        case .anniversary:
            return "suit.heart.fill"
        case .simpleEvent:
            return "sparkles"
        }
    }

    init(eventDate: Date, eventType :EventTypeEnum, title: String, id: String, congratulation: String? = nil, notificationIds: [String] = []) {
        self.id = id
        self.eventDate = eventDate
        self.eventType = eventType
        self.title = title
        self.notificationIds = notificationIds
        self.imagePath = getImageSystemName(eventType: eventType)
        self.congratulation = congratulation
    }
    
    init(eventType: EventTypeEnum) {
        self.id = UUID().uuidString
        self.eventDate = .now
        self.title = ""
        self.eventType = eventType
        self.notificationIds = []
        self.imagePath = getImageSystemName(eventType: eventType)
        self.congratulation = nil
    }
    
    enum ConfigKeys: String, CodingKey {
        case id
        case congratulation
        case eventDate
        case eventType
        case title
        case imagePath
        case notificationBefore
        case notificationIds
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ConfigKeys.self)
        self.id = try values.decodeIfPresent(String.self, forKey: .id)!
        self.congratulation = try values.decodeIfPresent(String.self, forKey: .congratulation)
        self.eventDate = try values.decodeIfPresent(Date.self, forKey: .eventDate)!
        self.eventType = try values.decodeIfPresent(EventTypeEnum.self, forKey: .eventType)!
        self.title = try values.decodeIfPresent(String.self, forKey: .title)!
        self.notificationIds = try values.decodeIfPresent([String].self, forKey: .notificationIds) ?? []
        self.imagePath = try values.decodeIfPresent(String.self, forKey: .imagePath)!
    }
}


extension MainEvent: Equatable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.congratulation)
        hasher.combine(self.eventDate)
        hasher.combine(self.title)
        hasher.combine(self.imagePath)
        hasher.combine(self.eventType)
        hasher.combine(self.notificationIds)
    }
    
    static func == (lhs: MainEvent, rhs: MainEvent) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
