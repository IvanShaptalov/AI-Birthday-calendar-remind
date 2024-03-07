//
//  WishCreatorStep2.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 07.03.2024.
//

import UIKit

protocol WishTransferProtocol{
    var wish: WishType? { get set }
}

class WishCreatorStep2: UIViewController, WishTransferProtocol{
    var wish: WishType?
    
    @IBOutlet weak var titleLabel: UILabel!

  
    @IBOutlet weak var whoWish: UIButton!
    
    @IBOutlet weak var messageStyle: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = wish?.rawValue ?? "Create Wish"
        self.setUpWhoCelebrating()
        self.setUpMessageStyle()
      
    }
    
    private func setUpMessageStyle(){
        MessageStylePulldownButton.setWhoWish(button: &self.messageStyle)
    }
    
    private func setUpWhoCelebrating(){
        WhoWishPulldownButton.setWhoWish(button: &whoWish, values: WhoWish.allValuesCorrespondingTo(wish: self.wish!))
    }
    
    @IBAction func generateWish(_ sender: UIButton) {
        
    }
}
