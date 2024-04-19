//
//  SubscriptionProposer.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 11.03.2024.
//

import Foundation
import UIKit


class SubscriptionProposer {
    static func forceProVersionRecordsLimited(viewController: UIViewController){
        if !RevenueCatProductsProvider.subscriptionList.isEmpty{
            let paywall = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PaywallScreen") as! PaywallController
            
            // MARK: - Update after dismiss
            paywall.updateDelegate = { if viewController is BirthdaysScreen {
                (viewController as! BirthdaysScreen).tableEvents?.reloadData()
                (viewController as! BirthdaysScreen).setUpPremiumBadge()
            }}
            
            paywall.updateDelegate = { if viewController is ShareScreen {
                (viewController as! ShareScreen).setUpExportMenu()
            }}
            
            viewController.present(paywall, animated: true)
           
            // to show this page only one time
            AppConfiguration.isLaunchedEarlier = true
            
        }
    }
}
