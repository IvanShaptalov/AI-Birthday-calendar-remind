//
//  NotificationSettingsScreen.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 27.02.2024.
//

import UIKit

class NotificationSettingsScreen: UITableViewController {
    
    @IBOutlet weak var notificationTime: UIDatePicker!
    
    // MARK: - Time for birthday and anniversary
    @IBAction func notificationTimeSelected(_ sender: UIDatePicker) {
    }
    
    // MARK: - Birthday & Anniversary
    @IBOutlet weak var notificationOnBirthdayAndAnniversary: UISwitch!
    
    @IBOutlet weak var notificateDaysBefore: UISwitch!
    
    @IBOutlet weak var daysBeforeBirthdayAndAnniversary: UIButton!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestNotificationPermissionIfNeeded()
        self.setUpPulldownNotificateBefore()
        self.setUpNotificationSwithAndDate()
        
    }
    
    private func setUpNotificationSwithAndDate(){
        self.notificationTime.setDate(AppConfiguration.notificationTime, animated: false)
        self.notificationOnBirthdayAndAnniversary.setOn(AppConfiguration.isNotificateSameDay, animated: false)
        self.notificateDaysBefore.setOn(AppConfiguration.isNotificateDaysBefore, animated: false)
    }
    
    private func setUpPulldownNotificateBefore(){
        DaysBeforePulldownButton.setUpDaysBefore(button: &daysBeforeBirthdayAndAnniversary, menuClosure: {action in
            NSLog("birthday: selected \(action.title)")
            AppConfiguration.notificateBeforeInDays = NotificateBeforeEnum(rawValue: action.title.lowercased()) ?? .none
            
        })
    }
    
    private func requestNotificationPermissionIfNeeded(){
        PermissionProvider.registerForRemoteNotification(userDeniedNotification: {userDeniedNotifications in
            if userDeniedNotifications {
                let alertController = UIAlertController(title: "Enable notifications", message: "Go to settings & privacy to re-enable AI Birthday notifications", preferredStyle: .alert)
                
                alertController.addAction(.init(title: "OK", style: .default))
                
                self.present(alertController, animated: true)
            }
            
        })
        
    }
    
    @IBAction func notificationTimeValueChanged(_ sender: UIDatePicker) {
        AppConfiguration.notificationTime = sender.date
    }
    
    @IBAction func notificateDaysBeforeChanged(_ sender: UISwitch) {
        AppConfiguration.isNotificateDaysBefore = sender.isOn
    }
    
    
    @IBAction func notificateOnSameDayChanged(_ sender: UISwitch) {
        AppConfiguration.isNotificateSameDay = sender.isOn
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        NSLog(cell?.description ?? "ss")
    }
}
