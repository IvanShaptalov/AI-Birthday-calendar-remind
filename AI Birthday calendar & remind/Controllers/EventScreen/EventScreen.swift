//
//  BirthdaysScreen.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 21.02.2024.
//

import UIKit
let reuseIdentifier = "EventCell"
class BirthdaysScreen: UIViewController{

    @IBOutlet weak var tableEvents: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.tableEvents.register(.init(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
}

extension BirthdaysScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    
    
    // MARK: - Configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventCell
        
        cell.timeLeft.text = "22 days left"
        
        return cell
    }
    
    
}
