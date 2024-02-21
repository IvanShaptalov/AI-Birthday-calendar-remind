//
//  Storage.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 21.02.2024.
//

import Foundation


// MARK: - MainEventStorage

class MainEventStorage {
    static func save(_ eList: [MainEvent]) {
        StorageConfiguration.storage!.set(MainEventJsonCoder.toJson(eList), forKey: StorageConfiguration.mainEvent)
    }
    
    static func load() -> [MainEvent] {
        guard let eJson: String = StorageConfiguration.storage!.string(forKey: StorageConfiguration.mainEvent) else {
            return []
        }
        
        let e = MainEventJsonCoder.fromJson(eventListJson: eJson)
        
        return e
    }
    
    static func reset() {
        StorageConfiguration.storage!.removeObject(forKey: StorageConfiguration.mainEvent)
    }
}
