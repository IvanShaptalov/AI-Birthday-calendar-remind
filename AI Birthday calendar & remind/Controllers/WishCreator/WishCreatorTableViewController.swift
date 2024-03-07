//
//  WishCreatorTableViewController.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 07.03.2024.
//

import UIKit

class WishCreatorTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return WishType.allValuesRaw().count

    }
    
    // MARK: - CONFIGURE CELL
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wishCell", for: indexPath)
        
        var conf = cell.defaultContentConfiguration()
        
        conf.image = UIImage(systemName: WishType.allValues()[indexPath.row].getImageSystemName())
        
        conf.text = WishType.allValuesRaw()[indexPath.row]
        
        
        
        cell.contentConfiguration = conf
        
        

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var step2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WishCreatorStep2") as! WishTransferProtocol
        
        step2.wish = WishType.allValues()[indexPath.row]
        self.present((step2 as! UIViewController), animated: true)
    }
}
