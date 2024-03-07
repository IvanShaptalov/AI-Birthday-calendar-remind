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
    
    var whoWishEnum: WhoWish = .friend
    
    var messageStyleEnum: MessageStyle = .casual
    
    var prominentWhoWist: String?
    
    var prominentMessageStyle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = wish?.rawValue ?? "Create Wish"
        self.setUpWhoCelebrating()
        self.setUpMessageStyle()
      
    }
    
    @IBAction func editingWishToEnd(_ sender: UITextField) {
        if sender.text == ""{
            self.prominentWhoWist = nil
        } else {
            self.prominentWhoWist = sender.text
        }
    }
    @IBAction func editingMessageStyleEnd(_ sender: UITextField) {
        if sender.text == ""{
            self.prominentMessageStyle = nil
        } else {
            self.prominentMessageStyle = sender.text
        }
    }
    private func setUpMessageStyle(){
        MessageStylePulldownButton.setWhoWish(button: &self.messageStyle, menuClosure: {action in
            self.messageStyleEnum = MessageStyle(rawValue: action.title) ?? self.messageStyleEnum
        })
    }
    
    private func setUpWhoCelebrating(){
        WhoWishPulldownButton.setWhoWish(button: &whoWish, values: WhoWish.allValuesCorrespondingTo(wish: self.wish!), menuClosure: {action in
            self.whoWishEnum = WhoWish(rawValue: action.title) ?? self.whoWishEnum
            
        })
    }
    
    @IBAction func generateWish(_ sender: UIButton) {
        
    }
}
