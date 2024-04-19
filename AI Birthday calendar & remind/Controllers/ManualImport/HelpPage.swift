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
18.04.2002 - Sakura
2002-04-19 , Aarav
04/20/2002 ! Luna
17/02/2002 ? Mateo
04-22-2002 ; Aisha
2002/04/23 : Javier
24 Apr 2002 - Hikari
Apr 25, 2002 _ Mohammed
2002/Apr/26 - Leila
17-04-2001 , Nikolai
2002.04.17 ! Sofia
17 Apr 2000 ? Elijah
Apr-12-1999 ; Zara
2002 Apr 11 : Rafael
10/04/2002 00:00:00 - Ayumi
04/09/2002 00:00:00 _ Kai
08.04.2002 00:00:00 _ Luca
Apr 07, 2002 00:00:00 - Isabella
2002/Apr/06 00:00:00 _ Akira
"""
        let alert = UIAlertController(title: "Copied to clipboard ✅", message: "events copied to clipboard", preferredStyle: .alert)
        
        alert.addAction(.init(title: "OK", style: .default))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

