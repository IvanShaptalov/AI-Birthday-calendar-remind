//
//  WishCreatorTableViewController.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 07.03.2024.
//
import UIKit

class WishCreatorTableViewController: UITableViewController {
    
    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source ⚙️
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // MARK: - Rows in section ⚙️
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return WishType.allValuesRaw().count
        
    }
}

// MARK: - EXT Table Methods
extension WishCreatorTableViewController {
    // MARK: - CONFIGURE CELL ⚙️
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "wishCell", for: indexPath)
        
        setupCell(cell: &cell, index: indexPath.row)
        
        return cell
    }
    
    private func setupCell(cell: inout UITableViewCell, index: Int) {
        var conf = cell.defaultContentConfiguration()
        
        conf.image = UIImage(systemName: WishType.allValues()[index].getImageSystemName())?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
        
        conf.text = WishType.allValuesRaw()[index]
        
        cell.contentConfiguration = conf
    }
    
    // MARK: - Selection row ⚙️
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectCell(index: indexPath.row)
        
    }
    
    private func selectCell(index: Int) {
        let step2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WishCreatorStep2") as! WishCreatorStep2
        
        let viewModel = WishStep2ViewModel(wish: WishType.allValues()[index])
        
        step2.viewModel = viewModel
        
        self.present(step2, animated: true)
    }
}
