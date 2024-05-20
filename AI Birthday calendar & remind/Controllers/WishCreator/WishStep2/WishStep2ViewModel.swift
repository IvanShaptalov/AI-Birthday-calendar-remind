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
}
