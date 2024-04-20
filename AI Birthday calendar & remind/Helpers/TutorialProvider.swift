//
//  TutorialProvider.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 28.03.2024.
//

import Foundation


class TutorialProvider {
    static func getCards() -> [MainEvent]{
        let c = Calendar.current
        return [                .init(eventDate: c.date(bySetting: .month, value: 3, of: .now)!, eventType: .simpleEvent, title: "✨ Create unique wishes", id: UUID().uuidString),
                                .init(eventDate: c.date(bySetting: .month, value: 7, of: .now)!, eventType: .anniversary, title: "🚛 import & export birthdays", id: UUID().uuidString),
                                .init(eventDate: c.date(bySetting: .month, value: 9, of: .now)!, eventType: .birthday, title: "⚙️ Set up notifications", id: UUID().uuidString)]
    }
    
    /// if app not launched earlier - load cards
    static func isAwailableToAddCards() -> Bool {
        return !AppConfiguration.isLaunchedEarlier
    }
}
