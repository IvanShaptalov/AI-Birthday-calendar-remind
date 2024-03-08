//
//  SettingsScreen.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 26.02.2024.
//

import UIKit

class SettingsScreen: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(indexPath)")
        self.selectAction(indexPath: indexPath)
        
    }

}

// MARK: - Cell functions
extension SettingsScreen {
    private func rateApp(){
        RateProvider.rateApp()
    }
    
    private func importFromCalendar(){
        
    }
    
    private func importFromText(){
        
    }
    
    private func exportAsText(){
        
    }
    
    private func exportAsTable(){
        
    }
    
    private func contactUs(){
        AnalyticsManager.shared.logEvent(eventType: .contactUsOpened)
        UIApplication.shared.open(URL(string: AppConfiguration.contactUsURL)!, options: [:], completionHandler: nil)
    }
    
    private func privacyPolicy(){
        UIApplication.shared.open(URL(string: AppConfiguration.privacyPolicyURL)!, options: [:], completionHandler: nil)
    }
    
    // MARK: - Action Selecting
    func selectAction(indexPath: IndexPath){
        // Notifications
//        if indexPath.section == 1{
//            NSLog("\(indexPath.section): Notifications")
//            return
//        }
//        // Import
//        if indexPath.section == 2 {
//            if indexPath.row == 0{
//                NSLog("Import From Contacts")
//                self.importFromCalendar()
//                return
//            }
//            if indexPath.row == 1{
//                NSLog("Import From Calendar")
//                self.importFromCalendar()
//                return
//            }
//            if indexPath.row == 2 {
//                NSLog("Import from Text")
//                self.importFromText()
//                return
//            }
//        }
//        
//        // Export
//        if indexPath.section == 3 {
//            if indexPath.row == 0 {
//                NSLog("Export as text file")
//                self.exportAsText()
//                return
//            }
//            if indexPath.row == 1 {
//                NSLog("Export as table file")
//                self.exportAsTable()
//                return
//            }
//        }
//        // Promotion
//        if indexPath.section == 4 {
//            if indexPath.row == 0 {
//                NSLog("Rate App")
//                self.rateApp()
//                return
//            }
//            if indexPath.row == 1 {
//                NSLog("Contact Us")
//                self.contactUs()
//                return
//            }
//            if indexPath.row == 2 {
//                NSLog("Privacy Policy")
//                self.privacyPolicy()
//                return
//            }
//        }
        
        if indexPath.section == 1{
            NSLog("\(indexPath.section): Notifications")
            return
        }
        // Import
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                NSLog("Rate App")
                self.rateApp()
                return
            }
            if indexPath.row == 1 {
                NSLog("Contact Us")
                self.contactUs()
                return
            }
            if indexPath.row == 2 {
                NSLog("Privacy Policy")
                self.privacyPolicy()
                return
            }
        }
       
        
        
    }
}

