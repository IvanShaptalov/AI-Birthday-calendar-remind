//
//  SubscriptionProposer.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 11.03.2024.
//

import Foundation
import UIKit


class SubscriptionProposer {
    static func proposeProVersionRecordsLimited(viewController: UIViewController){
        let alertController = UIAlertController(title: "Unlock all features", message: "count of records limited to \(MonetizationConfiguration.freeEventRecords), opt to using pro version to unlock all features", preferredStyle: .alert)
        
        alertController.addAction(.init(title: "Later", style: .cancel, handler:nil))
        alertController.addAction(.init(title: "Upgrade", style: .default, handler: {action in
            
            let paywall = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PaywallScreen")
            
            viewController.present(paywall, animated: true)
        }))
        
        viewController.present(alertController, animated: true)
    }
}
