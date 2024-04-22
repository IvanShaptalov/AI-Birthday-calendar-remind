//
//  SettingsScreen.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 26.02.2024.
//

import UIKit

class SettingsScreen: UITableViewController {

    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - tableSelection ⚙️
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(indexPath)")
        self.selectAction(indexPath: indexPath)
    }

}

// MARK: - Cell functions **EXT ✨
extension SettingsScreen {
    // MARK: - Rate App 📈
    private func rateApp(){
        RateProvider.rateApp()
    }
    
    // MARK: - Import from calendar 🚛📅
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
                AnalyticsManager.shared.logEvent(eventType: .eventsImportedCalendarReminders)
            }
            
            
            
            self.present(addEvScreen, animated: true)
        }
        
        
        
    }
    
    // MARK: - Export As Text 🛳️📜
    private func exportAsText(){
        
    }
    
    // MARK: - Export to Calendar
    private func exportToCalendar(){
        
    }
    
    private func exportToReminders(){
        
    }
    
    
    // MARK: - Export to Reminders
    
    // MARK: - Restore purchases 💰
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
    
    // MARK: - Contact us 🤙
    private func contactUs(){
        AnalyticsManager.shared.logEvent(eventType: .contactUsOpened)
        UIApplication.shared.open(URL(string: AppConfiguration.contactUsURL)!, options: [:], completionHandler: nil)
    }
    
    // MARK: - Privacy policy 👮
    private func privacyPolicy(){
        UIApplication.shared.open(URL(string: AppConfiguration.privacyPolicyURL)!, options: [:], completionHandler: nil)
    }
    
    
    // MARK: - Select action ⚙️
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

