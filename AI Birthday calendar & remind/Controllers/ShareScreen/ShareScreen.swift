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
        
    @IBOutlet weak var separatorField: UITextField!
    
    @IBOutlet weak var switchButton: UIBarButtonItem!
    
    @IBOutlet weak var formattedEventsView: UITextView!
    
    
    var events: [MainEvent] = []
    
    var selectedFormat = "dd/MM/yyyy"

    var switcherIsTitleFirst = false

    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("events to share: \(events)")
        self.setUpExportMenu()
        self.convertEvents()
        self.setupDateFormatMenu()
        
    // MARK: - Keyboard dismissing
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    // MARK: - Text editing
    @IBAction func editingChangedTextField(_ sender: UITextField) {
        self.convertEvents()
    }
    
    // MARK: - switch Button clicked
    @IBAction func switchButtonTapped(_ sender: UIBarButtonItem) {
        switcherIsTitleFirst = !switcherIsTitleFirst
        self.convertEvents()
    }
    
    // MARK: - Separator field
    @IBAction func separatorValueChanged(_ sender: Any) {
        self.convertEvents()
    }
    
    // MARK: - setUp Button Menus 🤖
    private func setupDateFormatMenu(){
        DateFormatterPulldownButton.setup(button: &self.dropdownButtonFormat, menuClosure: {action in
            
            DispatchQueue.main.async {
                self.selectedFormat = action.title
                self.convertEvents()
            }
        })
    }
    
    private func setUpExportMenu(){
        let optionsClosure = {(action: UIAction) in
            guard let actEnum = ExportTo(rawValue: action.title) else {
                return
            }
            
            switch actEnum {
                
            case .toReminder:
                self.toReminders()
            case .toCalendar:
                self.toCalendar()
            case .asText:
                self.toText()
            case .asTable:
                self.toTable()
            case .copyToClipboard:
                self.toClipboard()
            }
            
            
        }
        var children : [UIAction] = []
        
        for exportEnum in ExportTo.all() {
            children.append(UIAction(title: exportEnum.rawValue, handler: optionsClosure))
        }
                
        self.dropdownButtonExport.menu = UIMenu(children: children)
    }
    
    
    
    
    
    // MARK: - setup formatted event as text
    private func convertEvents(){
        let defaultSeparator = ","
        var separator = self.separatorField.text ?? defaultSeparator
        
        if separator == "" {
            separator = defaultSeparator
        }
        
        var formattedEvents: [String] = []
        
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = selectedFormat
        
        if switcherIsTitleFirst {
            formattedEvents = events.map { "\($0.title) \(separator) \(formatter.string(from: $0.eventDate))" }
        } else {
            formattedEvents = events.map {
                "\(formatter.string(from: $0.eventDate)) \(separator) \($0.title)" }
        }
        
        
        
        
        let text = formattedEvents.joined(separator: "\n")
        
        self.formattedEventsView.text = text
    }
    
    // MARK: - Send to export
    private func toClipboard(){
        ClipBoardEventExporter(formattedText: self.formattedEventsView.text, events: self.events).export()
        let alert = UIAlertController(title: "Copied to clipboard ✅", message: "events copied to clipboard", preferredStyle: .alert)
        
        alert.addAction(.init(title: "OK", style: .default))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func toText(){
        if let fileURL = TextFileEventExporter(formattedText: self.formattedEventsView.text, events: self.events).export() {
             
            FileSharing.share(viewController: self, fileURL: fileURL)
        }
    }
    
    private func toTable(){
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = selectedFormat
        
        if let tableURL = TableEventExporter(formattedText: self.formattedEventsView.text, events: self.events).export(isTitleFirst: self.switcherIsTitleFirst, formatter: formatter) {
            FileSharing.share(viewController: self, fileURL: tableURL)

        }
    }
    
    // MARK: - export to reminders 🚛⏰
    private func toReminders(){
        PermissionProvider.registerForReminders(completion: {denied, status in
            if denied {
                NSLog("⏰🪓 reminder status: \(status)")
                
                let alertController = UIAlertController(title: "Enable ⏰ Reminders", message: "Go to settings & privacy to re-enable AI Birthday Calendar Reminders", preferredStyle: .alert)
                
                alertController.addAction(.init(title: "OK", style: .default))
                
                self.present(alertController, animated: true)
                
            } else {
                NSLog("⏰ reminders: ✅ \(status)")
            }
            
        })
        
        if PermissionProvider.checkCalendarAccess(forType: .reminder) {
            ReminderEventExporter(formattedText: self.formattedEventsView.text, events: self.events).export()
        }
    }
    
    // MARK: - export to calendar 🚛📅
    private func toCalendar(){
        PermissionProvider.registerForEvents(completion: {denied, status in
            if denied {
                NSLog("📅🪓 event status: \(status)")
                
                let alertController = UIAlertController(title: "Provide 📆 Calendar Full Access", message: "Go to settings & privacy to re-enable AI Birthday Calendar Full Access", preferredStyle: .alert)
                
                alertController.addAction(.init(title: "OK", style: .default))
                
                self.present(alertController, animated: true)
            } else {
                NSLog("📆 events: ✅ \(status)")
            }
        })
        
        if PermissionProvider.checkCalendarAccess(forType: .event) {
            CalendarEventExporter(formattedText: self.formattedEventsView.text, events: self.events).export()
        }
        
    }
  
}

