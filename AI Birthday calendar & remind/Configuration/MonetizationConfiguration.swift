//
//  MonetizationConfiguration.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 06.03.2024.
//

import Foundation


class MonetizationConfiguration {
    static var isPremiumAccount: Bool = false
    
    static var freeEventRecords: Int = 5
    
    
    static func getRecordsForAccount() -> Int{
        if isPremiumAccount{
            return -1
        }
        return freeEventRecords
    }
    
    static func fetchFirebase() {
        freeEventRecords = RemoteConfigWrapper.shared.remoteConfig.configValue(forKey: "freeRecords").numberValue as? Int ?? freeEventRecords
        
        NSLog("🪙 free events: \(freeEventRecords)")
    }
}
