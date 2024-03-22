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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        
        PermissionProvider.registerForEvents(completion: {denied, status in
            if denied {
                NSLog("📅🪓 event status: \(status)")
                
                let alertController = UIAlertController(title: "Provide 📆 Calendar Full Access", message: "Go to settings & privacy to re-enable AI Birthday Calendar Full Access", preferredStyle: .alert)
                
                alertController.addAction(.init(title: "OK", style: .default))
                
                self.present(alertController, animated: true)
            } else {
                NSLog("📆 events: ✅ \(status)")
            }
        })
        
        PermissionProvider.registerForReminders(completion: {denied, status in
            if denied {
                NSLog("⏰🪓 reminder status: \(status)")
                
                let alertController = UIAlertController(title: "Enable ⏰ Reminders", message: "Go to settings & privacy to re-enable AI Birthday Calendar Reminders", preferredStyle: .alert)
                
                alertController.addAction(.init(title: "OK", style: .default))
                
                self.present(alertController, animated: true)
                
            } else {
                NSLog("⏰ reminders: ✅ \(status)")
            }
            
        })
        
        // MARK: - Transfer & Save imported data
        if PermissionProvider.checkCalendarAccess(forType: .event) && PermissionProvider.checkCalendarAccess(forType: .reminder){
            let importedEvents: [MainEvent] = RemindersProvider.importData() + EventsProvider.importData()
            print(importedEvents.count)
            
            let addEvScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddEventsScreen") as! AddEventScreen
            
            // add imported events
            addEvScreen.updateEventsSafe(events: importedEvents)
            
            // save date
            addEvScreen.bulkDelegate = {eventList in
                // loaded events + new
                
                let loadedEvents = MainEventStorage.load()
                var resultEvents : [MainEvent] = []
                for ev in loadedEvents + eventList {
                    if !resultEvents.contains(where: {$0.id == ev.id}) {
                        resultEvents.append(ev)
                    }
                }
                MainEventStorage.save(resultEvents)
            }
            
            
            
            self.present(addEvScreen, animated: true)
        }
        
        
        
    }
    
    private func importFromContacts(){
        
    }
    
    private func importFromText(){
        
    }
    
    private func exportAsText(){
        
    }
    
    private func exportAsTable(){
        
    }
    
    private func restorePurchase(){
        RevenueCatProductsProvider.restorePurchase(callback: {isPremium in
            var message = "No active subscriptions 💤"
            if isPremium {
                message = "Subscription restored ✅"
            }
            let alert = UIAlertController(title: "Restore Subscription", message: message, preferredStyle: .alert)
            
            alert.addAction(.init(title: "Done", style: .default))
            
            DispatchQueue.main.async{
                self.present(alert, animated: true)
            }
        })
    }
    
    private func contactUs(){
        AnalyticsManager.shared.logEvent(eventType: .contactUsOpened)
        UIApplication.shared.open(URL(string: AppConfiguration.contactUsURL)!, options: [:], completionHandler: nil)
    }
    
    private func privacyPolicy(){
        UIApplication.shared.open(URL(string: AppConfiguration.privacyPolicyURL)!, options: [:], completionHandler: nil)
    }
    
    // MARK: - Action Selecting
    //    func selectAction(indexPath: IndexPath){
    //        // Notifications
    //        if indexPath.section == 1{
    //            NSLog("\(indexPath.section): Notifications")
    //            return
    //        }
    //        // Import
    //        if indexPath.section == 2 {
    //            if indexPath.row == 0{
    //                NSLog("Import From Contacts")
    //                self.importFromContacts()
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
    //        
    //        
    //    }
    
    func selectAction(indexPath: IndexPath){
        if indexPath.section == 1{
            NSLog("restore purchase")
            self.restorePurchase()
            return
        }
        // Notifications
        if indexPath.section == 2{
            NSLog("\(indexPath.section): Notifications")
            return
        }
        // Import
        if indexPath.section == 3 {
            
            if indexPath.row == 0{
                NSLog("Import From Calendar")
                self.importFromCalendar()
                return
            }
            
        }
        
        
        
        // Promotion
        if indexPath.section == 4 {
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

