//
//  ShareScreen.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 18.04.2024.
//

import UIKit



class ShareScreen: UIViewController {
    // MARK: - Fields 🌾
    @IBOutlet weak var dropdownButtonFormat: UIButton!
   
    @IBOutlet weak var dropdownButtonExport: UIButton!
    
    @IBOutlet weak var pulldownButtonSeparator: UIButton!
    
    @IBOutlet weak var switchButton: UIBarButtonItem!
    
    @IBOutlet weak var formattedEventsView: UITextView!
    
    @IBAction func switchButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    var events: [MainEvent] = []

    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("events to share: \(events)")
        self.setUpExportMenu()
        self.setUpFormatMenu()
        self.setupFormattedEventText()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // MARK: - setUpButtonMenus 🤖
    private func setUpFormatMenu(){
        let optionsClosure = { (action: UIAction) in
            print(action.title)
          }
        self.dropdownButtonFormat.menu = UIMenu(children: [
            UIAction(title: "Option 1", handler: optionsClosure),
            UIAction(title: "Option 2", handler: optionsClosure),
            UIAction(title: "Option 3", handler: optionsClosure)
          ])
    }
    
    private func setUpExportMenu(){
        let optionsClosure = {(action: UIAction) in
            print(action.title)
        }
        var children : [UIAction] = []
        for exportEnum in ExportTo.all() {
            children.append(UIAction(title: exportEnum.rawValue, handler: optionsClosure))
        }
                
        self.dropdownButtonExport.menu = UIMenu(children: children)
    }
    
    // MARK: - setup formatted event as text
    private func setupFormattedEventText(){
        var text = ""
        for event in events {
            text.append("\(event.title),\(event.eventDate.formatted()) \n")
        }
        
        
        self.formattedEventsView.text = text
    }
  
}
