//
//  NotificationSettingsScreen.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 27.02.2024.
//

import UIKit

class NotificationSettingsScreen: UITableViewController {
    
    private func requestNotificationPermissionIfNeeded(){
        PermissionProvider.registerForRemoteNotification(userDeniedNotification: {userDeniedNotifications in
            if userDeniedNotifications {
                let alertController = UIAlertController(title: "Enable notifications", message: "Go to settings & privacy to re-enable AI Birthday notifications", preferredStyle: .alert)
                
                alertController.addAction(.init(title: "OK", style: .default))
                
                self.present(alertController, animated: true)
            }
            
        })
        
    }
    
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
