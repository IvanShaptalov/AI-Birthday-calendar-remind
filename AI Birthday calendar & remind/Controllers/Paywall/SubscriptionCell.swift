//
//  SubscriptionCell.swift
//  Learn Up
//
//  Created by PowerMac on 05.02.2024.
//

import UIKit

class SubscriptionCell: UITableViewCell {
    
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var checkMarkBadge: UIImageView!
    
    @IBOutlet weak var price_duration: UILabel!
        
    @IBOutlet weak var cellContent: UIView!
    
    @IBOutlet weak var discountView: UIView!
    
    @IBOutlet weak var borderView: UIView!
    
    private func roundDiscount() {
        self.discountView.layer.cornerRadius = 10
    }
    
    private func setBadge(fill: Bool) {
        if fill {
            checkMarkBadge.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            checkMarkBadge.image = UIImage(systemName: "checkmark.circle")
        }
    }
    
    func setDiscount(_ discount: Int){
        if discount == 0 {
            discountView.isHidden = true
        } else {
            discountView.isHidden = false
            self.discount.text = "\(discount)% OFF"
        }
    }
    
    func setSubDuration(offerDurationText: String?, priceDuration: String){
        if offerDurationText == nil {
            self.price_duration.text = priceDuration
        } else {
            self.price_duration.text = "\(offerDurationText!), then \(priceDuration)"
        }
    }
    
    private func setUpBorder() {
        self.borderView.layer.cornerRadius = 15
        self.borderView.layer.borderColor = UIColor.systemFill.cgColor
        self.borderView.layer.borderWidth = 1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpBorder()
        self.roundDiscount()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.borderView.layer.cornerRadius = 15
            self.borderView.layer.borderColor = UIColor.systemTeal.cgColor
            self.borderView.layer.borderWidth = 1.5
        } else {
            setUpBorder()
        }
        
        self.setBadge(fill: selected)
    }
    
}
