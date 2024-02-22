//
//  AddEventCell.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 22.02.2024.
//

import UIKit

class AddEventCell: UITableViewCell {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    var eventDelegate: ((String) -> Void)?
    
    @IBOutlet weak var pseudoView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pseudoView.layer.cornerRadius = 15
        self.selectionStyle = .none
        // Initialization code
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        NSLog("Editing changed")
        eventDelegate?(titleTextField.text ?? "")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
