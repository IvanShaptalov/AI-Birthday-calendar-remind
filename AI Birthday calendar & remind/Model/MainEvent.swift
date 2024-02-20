//
//  MainEvent.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 20.02.2024.
//

import Foundation

protocol MainEventProtocol {
    var eventDate: Date {get set}
    var eventType: EventTypeEnum {get set}
    var title: String {get set}
    var imagePath: String? {get set}
    
    func getImagePath(eventType rule: EventTypeEnum) -> String
}


class MainEvent: MainEventProtocol {
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
    
    
    var eventDate: Date
    var eventType: EventTypeEnum
    var title: String
    var imagePath: String?

    
    var notificationBefore: NotificateBeforeClass
    
    init(eventDate: Date, eventType :EventTypeEnum, title: String, rule: NotificateBeforeEnum) {
        self.eventDate = eventDate
        self.eventType = eventType
        self.title = title
        self.notificationBefore = NotificateBeforeClass(rule: rule)
        self.imagePath = getImagePath(eventType: eventType)
    }
}
