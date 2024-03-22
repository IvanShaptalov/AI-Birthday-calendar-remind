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
    
    
    static func saveIsLaunchedEarlier(_ isFLaunch: Bool) {
        StorageConfiguration.storage!.set(isFLaunch, forKey: StorageConfiguration.launchedBefore)
    }
    
    /// return
    static func loadIsLaunchedEarlier() -> Bool {
        let isFirstLaunch = StorageConfiguration.storage!.bool(forKey: StorageConfiguration.launchedBefore)
        NSLog("is launched earlier ⏰ : \(isFirstLaunch)")
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

// MARK: - Notifications
class SettingsNotificationStorage {
    static func saveNotificationDaysBefore(_ ndb: NotificateBeforeEnum){
        StorageConfiguration.storage!.set(ndb.rawValue, forKey: StorageConfiguration.notificateDaysBeforeEnumKey)
    }
    
    static func loadNotificationDaysBefore() -> NotificateBeforeEnum? {
        guard let raw = StorageConfiguration.storage!.string(forKey: StorageConfiguration.notificateDaysBeforeEnumKey) else {
            return nil
        }
        
        guard let ndb = NotificateBeforeEnum(rawValue: raw) else {
            return nil
        }
        
        return ndb
    }
    
    // MARK: - Days before
    static func saveIsNotificateDaysBefore(_ nb: Bool) {
        StorageConfiguration.storage!.set(nb, forKey: StorageConfiguration.isNotificateDaysBeforeKey)
    }
    
    static func loadIsNotificateDaysBefore() -> Bool{
        guard let ndb = StorageConfiguration.storage!.object(forKey: StorageConfiguration.isNotificateDaysBeforeKey) as? Bool else {
            return true
        }
    
        return ndb
    }
    
    // MARK: - Same day
    static func saveIsNotificateSameDay(_ nb: Bool) {
        StorageConfiguration.storage!.set(nb, forKey: StorageConfiguration.isNotificateSameDayKey)
    }
    
    static func loadIsNotificateSameDay() -> Bool{
        guard let ndb = StorageConfiguration.storage!.object(forKey: StorageConfiguration.isNotificateSameDayKey) as? Bool else {
            return true
        }
    
        return ndb
    }
    
    // MARK: - Notification time
    static func saveNotificationTime(date: Date){
        StorageConfiguration.storage!.set(date, forKey: StorageConfiguration.notificationTimeKey)
    }
    
    static func loadNotificationTime() -> Date{
        guard let optionDate = StorageConfiguration.storage!.object(forKey: StorageConfiguration.notificationTimeKey) as? Date else {
            let date = Calendar.current.date(bySettingHour: 8, minute: 00, second: 0, of: Date())!
            
            return date
        }
        
        return optionDate
        
    }
    
}
