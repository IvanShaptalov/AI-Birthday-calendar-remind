//
//  AppConfiguratino.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 21.02.2024.
//

import Foundation


class AppConfiguration {
    // MARK: - LINKS
    static var appStoreURL: String = "https://apps.apple.com/ua/app/ai-birthday-reminder-calendar/id6477883190"
    static var privacyPolicyURL: String = "https://t.me/aibcrprivacyPolicy"
    static var contactUsURL: String = "https://www.instagram.com/wellbeingvantage/"
    static var launchedEarlier = SettingsStorage.loadIsFirstLaunch()
    static var termsOfUseURL: String = "https://t.me/termsofuseAiBirthdayCalendar"
    
    // MARK: - RevenueCat
    static var revenuecat_project_apple_api_key = "appl_CnRVSaHJYkxyqjjVOOYidaPfVaH"

    
    // MARK: - NOTIFICATIONS
    static var notificationTime: Date = SettingsNotificationStorage.loadNotificationTime() {
        didSet {
            NSLog("🔔 new notification time : \(notificationTime)")
            SettingsNotificationStorage.saveNotificationTime(date: notificationTime)
            MainEventRuleUpdater.updateRules()

        }
    }
     
    // Notification before settings ENUM
    static var notificateBeforeInDays: NotificateBeforeEnum? = SettingsNotificationStorage.loadNotificationDaysBefore() {
        didSet {
            NSLog("🔔 new notificate before in days : \(notificateBeforeInDays?.rawValue ?? "nil")")
            if notificateBeforeInDays != nil {
                SettingsNotificationStorage.saveNotificationDaysBefore(notificateBeforeInDays!)
            }
            MainEventRuleUpdater.updateRules()

        }
    }
    
    // Notification before BOOL
    static var isNotificateDaysBefore: Bool =
    SettingsNotificationStorage.loadIsNotificateDaysBefore() {
        didSet {
            NSLog("🔔 is notificate days before : \(isNotificateDaysBefore)")

            SettingsNotificationStorage.saveIsNotificateDaysBefore(isNotificateDaysBefore)
            
            MainEventRuleUpdater.updateRules()

        }
    }
    
    // Notification same day BOOL
    static var isNotificateSameDay: Bool =
    SettingsNotificationStorage.loadIsNotificateSameDay() {
        didSet {
            NSLog("🔔 is notificate same day: \(isNotificateSameDay)")
            SettingsNotificationStorage.saveIsNotificateSameDay(isNotificateSameDay)
            MainEventRuleUpdater.updateRules()

        }
    }
    
    
    // MARK: - Gpt keys
    
    static var gptToken = "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"
    static var gptOrganization = "wellbeing.vantage"
    static var gptModel = "gpt-3.5-turbo-1106"
    
    static var gptModelList: [String] = ["gpt-3.5-turbo-1106",
                                         "gpt-3.5-turbo-0301",
                                         "gpt-3.5-turbo-16k-0613",
                                         "gpt-3.5-turbo-0613"]
    
    static var gptSystemPrompt = "Pretend that you congratulate from my name, it's VERY IMPORTANT"
    
    static var gptRequestSleepTime = 6
    
    static func switchGptModel(){
        NSLog("now: \(gptModel)")
        if gptModelList.contains(gptModel){
            let currentIndex = gptModelList.firstIndex(of: gptModel)
            if currentIndex! + 1 < gptModelList.count {
                gptModel = gptModelList[currentIndex! + 1]
            } else {
                gptModel = gptModelList.first!
            }
            NSLog("selected: \(gptModel)")
        }
    }
}


// MARK: - Fetching

class ConfigurationFetcher{
    static func fetch(){
        RemoteConfigWrapper.shared.remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                NSLog("Config fetched!")
                RemoteConfigWrapper.shared.remoteConfig.activate { changed, error in
                    //                        // MARK: - GPT fetching
                    NSLog("⚙️ Remote Config changed: \(changed)")
                    
                    
                    
                    AppConfiguration.contactUsURL = RemoteConfigWrapper.shared.remoteConfig.configValue(forKey: "contactUsURL").stringValue ?? AppConfiguration.contactUsURL
                    
                    // MARK: - GPT Fetching
                    
                    AppConfiguration.gptToken = RemoteConfigWrapper.shared.remoteConfig.configValue(forKey: "gptToken").stringValue ?? AppConfiguration.gptToken
                    
                    AppConfiguration.gptSystemPrompt = RemoteConfigWrapper.shared.remoteConfig.configValue(forKey: "gptSystemPrompt").stringValue ?? AppConfiguration.gptSystemPrompt
                    
                    AppConfiguration.gptRequestSleepTime = RemoteConfigWrapper.shared.remoteConfig.configValue(forKey: "gptRequestSleepTime").numberValue as? Int ?? AppConfiguration.gptRequestSleepTime
                    
                    NSLog("⚙️ gptSystemPrompt: \(AppConfiguration.gptSystemPrompt)")
                    
                  
                    AppConfiguration.gptOrganization = RemoteConfigWrapper.shared.remoteConfig.configValue(forKey: "gptOrganization").stringValue ?? AppConfiguration.gptOrganization
                    
                    AppConfiguration.gptModel = RemoteConfigWrapper.shared.remoteConfig.configValue(forKey: "gptModel").stringValue ?? AppConfiguration.gptModel
                    
                    MonetizationConfiguration.fetchFirebase()
                    
                    let gptModelListRaw = RemoteConfigWrapper.shared.remoteConfig.configValue(forKey: "gptModelList").stringValue
                    
                    
                    
                    if gptModelListRaw != nil {
                        let splitted = gptModelListRaw?.components(separatedBy: ",")
                        if splitted != nil && !splitted!.isEmpty {
                            AppConfiguration.gptModelList = splitted!
                        }
                    }
                    
                    MonetizationConfiguration.fetchFirebase()
                }
                
            } else {
                NSLog("Config not fetched")
                NSLog("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
}
