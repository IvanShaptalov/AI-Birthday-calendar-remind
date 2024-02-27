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
    
    // MARK: - Birthday
    @IBOutlet weak var notificationOnBirthday: UISwitch!
    
    @IBOutlet weak var daysBeforeBirthday: UIButton!

    
    // MARK: - Anniversary
    @IBOutlet weak var notificationOnAnniversary: UISwitch!
    
    @IBOutlet weak var daysBeforeAnniversary: UIButton!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        requestNotificationPermissionIfNeeded()
        self.setUpPulldownNotificateBefore()
        
    }
    
    private func setUpPulldownNotificateBefore(){
        DaysBeforePulldownButton.setUpDaysBefore(button: &daysBeforeBirthday, menuClosure: {action in
                NSLog("birthday: selected \(action)")
        })
        DaysBeforePulldownButton.setUpDaysBefore(button: &daysBeforeAnniversary, menuClosure: {action in
                NSLog("anniversary: selected \(action)")
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
   
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        NSLog(cell?.description ?? "ss")
    }
}
