//
//  PulldownButtons.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 19.04.2024.
//

import Foundation
import UIKit


class DateFormatterPulldownButton {
    static public func setup(button: inout UIButton, menuClosure: @escaping (UIAction) -> () = {(action: UIAction) in }) {
        
        var children: [UIAction] = []
        
        for df in DATE_FORMATS {
            children.append(UIAction(title: "\(df)", handler: menuClosure))
        }
        button.menu = UIMenu(children: children)
    }
}
