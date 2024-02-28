//
//  AppConfiguratino.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 21.02.2024.
//

import Foundation


class AppConfiguration {
    // MARK: - LINKS
    static var appStoreURL: String = "https://www.instagram.com/wellbeingvantage/"
    static var privacyPolicyURL: String = "https://t.me/aibcrprivacyPolicy"
    static var contactUsURL: String = "https://www.instagram.com/wellbeingvantage/"
    static var launchedEarlier = SettingsStorage.loadIsFirstLaunch()
    
    // MARK: - NOTIFICATIONS
    static var notificationTime: Date = SettingsNotificationStorage.loadNotificationTime() {
        didSet {
            NSLog("🔔 new notification time : \(notificationTime)")
            SettingsNotificationStorage.saveNotificationTime(date: notificationTime)
        }
    }
     
    // Notification before settings ENUM
    static var notificateBeforeInDays: NotificateBeforeEnum? = SettingsNotificationStorage.loadNotificationDaysBefore() {
        didSet {
            NSLog("🔔 new notificate before in days : \(notificateBeforeInDays?.rawValue ?? "nil")")
            if notificateBeforeInDays != nil {
                SettingsNotificationStorage.saveNotificationDaysBefore(notificateBeforeInDays!)
            }
        }
    }
    
    // Notification before BOOL
    static var isNotificateDaysBefore: Bool =
    SettingsNotificationStorage.loadIsNotificateDaysBefore() {
        didSet {
            NSLog("🔔 is notificate days before : \(isNotificateDaysBefore)")

            SettingsNotificationStorage.saveIsNotificateDaysBefore(isNotificateDaysBefore)
        }
    }
    
    // Notification same day BOOL
    static var isNotificateSameDay: Bool =
    SettingsNotificationStorage.loadIsNotificateSameDay() {
        didSet {
            NSLog("🔔 is notificate same day: \(isNotificateSameDay)")
            SettingsNotificationStorage.saveIsNotificateSameDay(isNotificateSameDay)
        }
    }
}
