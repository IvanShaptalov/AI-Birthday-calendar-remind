//
//  RemoteConfiguration.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 06.03.2024.
//

import Foundation
import FirebaseRemoteConfigInternal


class RemoteConfigWrapper{
    var remoteConfig = RemoteConfig.remoteConfig()
    static let shared = RemoteConfigWrapper()
    let settings = RemoteConfigSettings()
    
    
    private init(){
        self.remoteConfig = RemoteConfig.remoteConfig()
        
        settings.minimumFetchInterval = 0
        settings.fetchTimeout = 10
        remoteConfig.configSettings = settings
        
    }
}
