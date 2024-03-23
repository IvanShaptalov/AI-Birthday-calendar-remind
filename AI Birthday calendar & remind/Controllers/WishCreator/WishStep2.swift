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
    
    @IBOutlet weak var messageStyleOpt: UITextField!
    
    @IBOutlet weak var receiverOpt: UITextField!
    
    @IBOutlet weak var ageCelebrator: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = wish?.rawValue ?? "Create Wish"
        self.setUpWhoCelebrating()
        self.setUpMessageStyle()
      
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
        var prWho: String? = nil
        var prMessageStyle: String? = nil
        var prName: String? = nil
        var prAge: String? = nil
        
        if receiverOpt.text != nil && !receiverOpt.text!.isEmpty {
            prWho = receiverOpt.text
        }
        
        if messageStyleOpt.text != nil && !messageStyleOpt.text!.isEmpty{
            prMessageStyle = messageStyleOpt.text
        }
        
        if ageCelebrator.text != nil && !ageCelebrator.text!.isEmpty {
            prAge = ageCelebrator.text
        }
        
        if nameField.text != nil && !nameField.text!.isEmpty {
            prName = nameField.text
        }
        
        
        
        let wishMaker = WishMaker(wishType: self.wish!.rawValue, toWho: prWho ?? whoWishEnum.rawValue, messageStyle: prMessageStyle ?? messageStyleEnum.rawValue, ageOpt: prAge, mentionsOpt: prName)
        sender.configuration?.showsActivityIndicator = true
        sender.isEnabled = false

        wishMaker.sendRequest(callback: {
            responseText in
                NSLog("⛑️: \(responseText)")
            DispatchQueue.main.async {
                AnalyticsManager.shared.logEvent(eventType: .wishStartGenerating)

                sleep(UInt32(AppConfiguration.gptRequestSleepTime))
                sender.configuration?.showsActivityIndicator = false
                var finish = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WishCreateFinish") as! WishResultTransferProtocol
                
                finish.wishResult = responseText
                sender.isEnabled = true
                self.present(finish as! UIViewController, animated: true)
            }
        }, error: {

            textError in
                NSLog("🧨 error in response: \(textError)")
            DispatchQueue.main.async {
                sender.isEnabled = true
                sender.configuration?.showsActivityIndicator = false
                AnalyticsManager.shared.logEvent(eventType: .wishNotGenerated)

            }
        })
    }
}
