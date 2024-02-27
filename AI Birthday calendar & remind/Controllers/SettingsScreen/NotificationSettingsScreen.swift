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
    
    // MARK: - Anniversary
    @IBOutlet weak var notificationOnAnniversary: UISwitch!
    
    private func requestNotificationPermissionIfNeeded(){
        PermissionProvider.registerForRemoteNotification(userDeniedNotification: {userDeniedNotifications in
            if userDeniedNotifications {
                let alertController = UIAlertController(title: "Enable notifications", message: "Go to settings & privacy to re-enable AI Birthday notifications", preferredStyle: .alert)
                
                alertController.addAction(.init(title: "OK", style: .default))
                
                self.present(alertController, animated: true)
            }
            
        })
        
    }
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        requestNotificationPermissionIfNeeded()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        NSLog(cell?.description ?? "ss")
    }
}
