//
//  DaysBeforePulldownButton.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 27.02.2024.
//

import Foundation
import UIKit


class DaysBeforePulldownButton {
    static public func setUpDaysBefore(button: inout UIButton, menuClosure: @escaping (UIAction) -> () = {(action: UIAction) in }) {
        
        var children: [UIAction] = []
        
        for notificateBefore in NotificateBeforeEnum.allValues {
            children.append(UIAction(title: "\(notificateBefore.rawValue)".capitalized, handler: menuClosure))
        }
        
        button.menu = UIMenu(children: children)
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        
        
    }
}
