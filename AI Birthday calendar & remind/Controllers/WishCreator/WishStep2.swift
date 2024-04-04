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
    // MARK: - Fields 🌾
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
    
    var buttonDisabled = false

    
    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = wish?.rawValue ?? "Create Wish"
        self.setUpWhoCelebrating()
        self.setUpMessageStyle()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    // MARK: - Set Up ⚙️
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
    
    // MARK: - Generate Wish 😘
    @IBAction func generateWish(_ sender: UIButton) {
        if buttonDisabled {
            NSLog("loading wish 💤")
            return
        }
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
        buttonDisabled = true
        
        wishMaker.sendRequest(callback: {
            responseText in
            
            DispatchQueue.main.async {
                if self.viewIfLoaded?.window != nil {
                        NSLog("⛑️: \(responseText)")
                        AnalyticsManager.shared.logEvent(eventType: .wishStartGenerating)
                        
                        sleep(UInt32(AppConfiguration.gptRequestSleepTime))
                        sender.configuration?.showsActivityIndicator = false
                        var finish = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WishCreateFinish") as! WishResultTransferProtocol
                        
                        finish.wishResult = responseText
                        self.buttonDisabled = false
                        self.present(finish as! UIViewController, animated: true)
                    
                } else {
                    NSLog("view not loaded 🔥")
                }
                
            }
            
        }, error: {
            
            textError in
            NSLog("🧨 error in response: \(textError)")
            DispatchQueue.main.async {
                self.buttonDisabled = false
                sender.configuration?.showsActivityIndicator = false
                AnalyticsManager.shared.logEvent(eventType: .wishNotGenerated)
                
            }
        })
    }
}
