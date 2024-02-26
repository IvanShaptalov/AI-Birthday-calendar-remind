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


class SettingsStorage {
    //MARK: - First launch
    
    
    static func saveIsFirstLaunch(_ isFLaunch: Bool) {
        StorageConfiguration.storage!.set(isFLaunch, forKey: StorageConfiguration.launchedBefore)
    }
    
    static func loadIsFirstLaunch() -> Bool {
        let isFirstLaunch = StorageConfiguration.storage!.bool(forKey: StorageConfiguration.launchedBefore)
        
        return isFirstLaunch
    }
    
    //MARK: - Rate
    static func saveRatedBefore(isRatedBefore: Bool) {
        StorageConfiguration.storage!.set(isRatedBefore, forKey: StorageConfiguration.ratedBefore)
        
    }
    
    static func loadRatedBefore() -> Bool {
        let ratedBefore = StorageConfiguration.storage!.bool(forKey: StorageConfiguration.ratedBefore)
        return ratedBefore
    }
    
    //MARK: - App version
    
    static func saveAppVersion(appVersion: String) {
        StorageConfiguration.storage!.set(appVersion, forKey: StorageConfiguration.appVersion)
    }
    
    static func loadAppVersion() -> String?{
        let appVersion: String? = StorageConfiguration.storage!.string(forKey: StorageConfiguration.appVersion)
        return appVersion
    }
}
