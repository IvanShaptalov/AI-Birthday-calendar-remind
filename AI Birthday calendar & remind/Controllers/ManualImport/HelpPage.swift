//
//  HelpPage.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 04.04.2024.
//

import UIKit

class HelpPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func copyButtonPressed(_ sender: UIBarButtonItem) {
        UIPasteboard.general.string = """
17.04.2002 - Sakura
2002-04-17 , Aarav
04/17/2002 ! Luna
17/04/2002 ? Mateo
04-17-2002 ; Aisha
2002/04/17 : Javier
17 Apr 2002 - Hikari
Apr 17, 2002 _ Mohammed
2002/Apr/17 - Leila
17-04-2002 , Nikolai
2002.04.17 ! Sofia
17 Apr 2002 ? Elijah
Apr-17-2002 ; Zara
2002 Apr 17 : Rafael
17/04/2002 00:00:00 - Ayumi
04/17/2002 00:00:00 _ Kai
17.04.2002 00:00:00 _ Luca
Apr 17, 2002 00:00:00 - Isabella
2002/Apr/17 00:00:00 _ Akira
"""
        sender.customView?.blink()
    }
}


extension UIView {
    func blink(duration: TimeInterval = 0.5, repeatCount: Float = .greatestFiniteMagnitude) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = repeatCount
        layer.add(animation, forKey: "blink")
    }
}
