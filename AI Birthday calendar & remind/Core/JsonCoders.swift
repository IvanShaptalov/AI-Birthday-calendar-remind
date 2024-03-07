//
//  JsonCoders.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 20.02.2024.
//

import Foundation

// MARK: - GeneratedMessage
class GeneratedMessageJsonCoder {
    
}


// MARK: - Words
class MainEventJsonCoder{
    static func toJson(_ events: [MainEvent]) -> String{
        do {
            return String(data: try JSONEncoder().encode<[MainEvent]>(events), encoding: String.Encoding.utf8)!
        } catch {
            return ""
        }
    }
    
    static func fromJson(eventListJson: String) -> [MainEvent] {
        var eventList: [MainEvent] = []
        do {
            let jsonDecoder = JSONDecoder()
            let jsonData = eventListJson.data(using: .utf8)!
            eventList = try jsonDecoder.decode([MainEvent].self, from: jsonData)
        }
        catch {
            eventList = []
        }
        return eventList
    }
    
    
}
