//
//  SubscriptionCell.swift
//  Learn Up
//
//  Created by PowerMac on 05.02.2024.
//

import UIKit

class SubscriptionCell: UITableViewCell {
    // MARK: - Fields 🌾
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var checkMarkBadge: UIImageView!
    
    @IBOutlet weak var price_duration: UILabel!
        
    @IBOutlet weak var cellContent: UIView!
    
    @IBOutlet weak var totalPrice: UILabel!
    
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var familySharingImage: UIImageView!
    
    @IBOutlet weak var familySharingLabel: UILabel!
        
    @IBOutlet weak var freeTrialLabel: UILabel!
    // MARK: - awakeFromNib ⚙️
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpBorder()
    }

    
    // MARK: - SetUp Functions ⚙️
    func setUpFreeTrial(isHidden: Bool) {
        self.freeTrialLabel.isHidden = isHidden
    }
    
    func setUpFamilySharing(isHidden: Bool) {
        self.familySharingImage.isHidden = isHidden
        self.familySharingLabel.isHidden = isHidden
    }
    private func setBadge(fill: Bool) {
        if fill {
            checkMarkBadge.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            checkMarkBadge.image = UIImage(systemName: "checkmark.circle")
        }
    }
    
    
    func setSubDuration(priceDuration: String){
        self.price_duration.text = priceDuration
    }
    
    func setTotalPrice(_ price: String){
        self.totalPrice.text = "\(price)$ total"
        
    }
    
    private func setUpBorder() {
        self.borderView.layer.cornerRadius = 15
        self.borderView.layer.borderColor = UIColor.systemFill.cgColor
        self.borderView.layer.borderWidth = 1
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
