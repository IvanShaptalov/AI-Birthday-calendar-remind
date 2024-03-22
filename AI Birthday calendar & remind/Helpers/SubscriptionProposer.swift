//
//  SubscriptionProposer.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 11.03.2024.
//

import Foundation
import UIKit


class SubscriptionProposer {
    
    /// return true if account premium or records less or equal to MonetizationConfiguration.freeRecordsCount
    static func hasNoLimitToRecords(eventsToAdd: [MainEvent]) -> Bool {
        if MonetizationConfiguration.isPremiumAccount {
            return true
        }
        
        let filteredEvents = eventsToAdd.filter{  $0.title != ""}
        
        // Load events from storage and get count
        let eventsFromStorageCount = MainEventStorage.load().count
        
        return (filteredEvents.count + eventsFromStorageCount) <= MonetizationConfiguration.freeEventRecords
    }
    
    static func hasNoLimitInMainScreen(_ events: [MainEvent]) -> Bool {
        return !MonetizationConfiguration.isPremiumAccount && events.count >= MonetizationConfiguration.freeEventRecords
    }
    
    static func proposeProVersionRecordsLimited(viewController: UIViewController){
        let alertController = UIAlertController(title: "Unlock all features", message: "count of records limited , opt to using pro version to unlock all features", preferredStyle: .alert)
        
        alertController.addAction(.init(title: "Later", style: .cancel, handler:nil))
        alertController.addAction(.init(title: "Upgrade", style: .default, handler: {action in
            
            let paywall = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PaywallScreen")
            
            viewController.present(paywall, animated: true)
        }))
        
        viewController.present(alertController, animated: true)
    }
    
    static func forceProVersionRecordsLimited(viewController: UIViewController){
        if !RevenueCatProductsProvider.subscriptionList.isEmpty{
            let paywall = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PaywallScreen")
            
            viewController.present(paywall, animated: true)
            // to show this page only one time
            AppConfiguration.isLaunchedEarlier = true
            
        }
    }
}
