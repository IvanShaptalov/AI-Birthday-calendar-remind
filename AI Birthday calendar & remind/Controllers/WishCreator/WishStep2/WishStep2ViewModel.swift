//
//  WishStep2ViewModel.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 20.05.2024.
//

import Foundation

protocol WishTransferProtocol{
    var wish: WishType? { get set }
}

final class WishStep2ViewModel: WishTransferProtocol {
    
    var wish: WishType?
    
    var celebratorTitle: String?
    
    var yearTurns: String?
    
    var whoWishEnum: WhoWish = .friend
    
    var messageStyleEnum: MessageStyle = .casual
    
    var buttonDisabled = false
    
    
    init(wish: WishType? = nil, celebratorTitle: String? = nil, yearTurns: String? = nil) {
        self.wish = wish
        self.celebratorTitle = celebratorTitle
        self.yearTurns = yearTurns
    }
    
    
    
}

extension WishStep2ViewModel {
    func setupMessageStyle( _ styleString: String) {
        self.messageStyleEnum = MessageStyle(rawValue: styleString) ?? self.messageStyleEnum
    }
    
    func setupToWhoWish( _ toWhoWishString: String) {
        self.whoWishEnum = WhoWish(rawValue: toWhoWishString) ?? WhoWish.friend
    }
    
    func prepareFieldsToMakeWish(optionalReceiver: String?, optionalMessageStyle: String?, optionalAgeCelebrator: String?, optionalNameField: String?) -> WishMaker? {
        if buttonDisabled {
            NSLog("loading wish 💤")
            return nil
        }
        var prWho, prMessageStyle, prName, prAge: String?
        
        
        if optionalReceiver != nil && !optionalReceiver!.isEmpty {
            prWho = optionalReceiver
        }
        
        if optionalMessageStyle != nil && !optionalMessageStyle!.isEmpty{
            prMessageStyle = optionalMessageStyle
        }
        
        if optionalAgeCelebrator != nil && !optionalAgeCelebrator!.isEmpty {
            prAge = optionalAgeCelebrator
        }
        
        if optionalNameField != nil && !optionalNameField!.isEmpty {
            prName = optionalNameField
        }
        
        let wishType = wish!.rawValue
        let toWho = prWho ?? whoWishEnum.rawValue
        let messageStyle = prMessageStyle ?? messageStyleEnum.rawValue        
        
        return WishMaker(wishType: wishType,
                         toWho: toWho,
                         messageStyle: messageStyle,
                         ageOpt: prAge,
                         mentionsOpt: prName)
    }
    //
    //    if buttonDisabled {
    //        NSLog("loading wish 💤")
    //        return
    //    }
    //    var prWho: String? = nil
    //    var prMessageStyle: String? = nil
    //    var prName: String? = nil
    //    var prAge: String? = nil
    //
    //    if receiverOpt.text != nil && !receiverOpt.text!.isEmpty {
    //        prWho = receiverOpt.text
    //    }
    //
    //    if messageStyleOpt.text != nil && !messageStyleOpt.text!.isEmpty{
    //        prMessageStyle = messageStyleOpt.text
    //    }
    //
    //    if ageCelebrator.text != nil && !ageCelebrator.text!.isEmpty {
    //        prAge = ageCelebrator.text
    //    }
    //
    //    if nameField.text != nil && !nameField.text!.isEmpty {
    //        prName = nameField.text
    //    }
    //
    //
    //
    //
    //    let wishMaker = WishMaker(wishType: self.wish!.rawValue, toWho: prWho ?? whoWishEnum.rawValue, messageStyle: prMessageStyle ?? messageStyleEnum.rawValue, ageOpt: prAge, mentionsOpt: prName)
    //    sender.configuration?.showsActivityIndicator = true
    //    buttonDisabled = true
    //
    //    wishMaker.sendRequest(callback: { [weak self]
    //        responseText in
    //
    //        DispatchQueue.main.async {
    //                    NSLog("⛑️: \(responseText)")
    //                    AnalyticsManager.shared.logEvent(eventType: .wishStartGenerating)
    //
    //                    sender.configuration?.showsActivityIndicator = false
    //                    var finish = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WishCreateFinish") as! WishResultTransferProtocol
    //
    //                    finish.wishResult = responseText
    //                    self?.buttonDisabled = false
    //                    self?.present(finish as! UIViewController, animated: true)
    //        }
    //
    //    }, error: {
    //
    //        textError in
    //        NSLog("🧨 error in response: \(textError)")
    //        if textError.lowercased().contains("limit") {
    //            let alertController = UIAlertController(title: "Day limit reached", message: "", preferredStyle: .alert)
    //
    //            alertController.addAction(.init(title: "OK", style: .default))
    //            DispatchQueue.main.async {
    //                self.present(alertController, animated: true)
    //
    //            }
    //        }
    //        DispatchQueue.main.async {
    //            self.buttonDisabled = false
    //            sender.configuration?.showsActivityIndicator = false
    //            AnalyticsManager.shared.logEvent(eventType: .wishNotGenerated)
    //
    //        }
    //    })
}
