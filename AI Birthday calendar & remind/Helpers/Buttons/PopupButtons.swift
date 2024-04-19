//
//  DaysBeforePulldownButton.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 27.02.2024.
//

import Foundation
import UIKit


class DaysBeforePopupButton {
    static public func setUpDaysBefore(button: inout UIButton, menuClosure: @escaping (UIAction) -> () = {(action: UIAction) in }) {
        
        var children: [UIAction] = []
        
        for notificateBefore in NotificateBeforeEnum.allValues {
            if notificateBefore == AppConfiguration.notificateBeforeInDays {
                
                children.append(UIAction(title: "\(notificateBefore.rawValue)".capitalized, state: .on, handler: menuClosure))
                
            } else {
                
                children.append(UIAction(title: "\(notificateBefore.rawValue)".capitalized, handler: menuClosure))
                
            }
        }
        button.menu = UIMenu(children: children)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        
        
    }
}


class WhoWishPopupButton {
    static public func setWhoWish(button: inout UIButton, values: [WhoWish], menuClosure: @escaping (UIAction) -> () = {(action: UIAction) in }) {
        
        var children: [UIAction] = []
        
        for notificateBefore in values {
            children.append(UIAction(title: "\(notificateBefore.rawValue)".capitalized, handler: menuClosure))
        }
        button.menu = UIMenu(children: children)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
    }
}


class MessageStylePopupButton {
    static public func setWhoWish(button: inout UIButton, menuClosure: @escaping (UIAction) -> () = {(action: UIAction) in }) {
        
        var children: [UIAction] = []
        
        for notificateBefore in MessageStyle.allValues() {
            children.append(UIAction(title: "\(notificateBefore.rawValue)".capitalized, handler: menuClosure))
        }
        button.menu = UIMenu(children: children)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
    }
}


