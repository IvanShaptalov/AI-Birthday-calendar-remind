//
//  ModifyAppIconTableViewController.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 09.05.2024.
//

import UIKit

let modifyAppIconReuseIdentifier = "modifyAppIcon"

class ModifyAppIconTableViewController: UITableViewController {
    
    @IBOutlet var iconsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iconsTable.register(UITableViewCell.self, forCellReuseIdentifier: modifyAppIconReuseIdentifier)
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AppConfiguration.appIconsNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: modifyAppIconReuseIdentifier, for: indexPath)
        
        // Create an image view
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) // Adjust the frame as per your requirement
        imageView.image = UIImage(named: AppConfiguration.appIconsNames[indexPath.row]) // Replace "yourImageName" with the name of your image asset
        
        cell.selectionStyle = .none
        // Add the image view as a subview to the cell
        
        cell.addSubview(imageView)
        
        cell.backgroundColor = indexPath.row % 2 == 0 ? .white : .iconsBackground
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !MonetizationConfiguration.isPremiumAccount {
            AnalyticsManager.shared.logEvent(eventType: .tryIconChange)
            SubscriptionProposer.forceProVersionPaywall(viewController: self)
        } else {
            AppIconChanger.changeIcon(name: AppConfiguration.appIconsNames[indexPath.row])
            { error  in
                if error != nil {
                    let alert = UIAlertController(title: "Icon Modifying", message: error!.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(.init(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
        
    }
}


