//
//  EventCell.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 21.02.2024.
//

import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var pseudoContent: UIView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var timeLeft: UILabel!
    
    @IBOutlet weak var dayOfWeekCalendarFormat: UILabel!
    
    @IBOutlet weak var dayAndMonth: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.pseudoContent.layer.cornerRadius = 15
        self.oldImage = eventImage

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var oldImage: UIImageView!
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
}
