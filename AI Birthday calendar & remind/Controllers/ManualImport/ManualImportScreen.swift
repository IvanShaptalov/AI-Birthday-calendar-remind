//
//  ManualImportScreen.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 03.04.2024.
//

import UIKit

class ManualImportScreen: UIViewController, UITextViewDelegate {
    
    // MARK: - Fields 🌾
    
    @IBOutlet weak var readyToImportLabel: UILabel!
    
    @IBOutlet weak var warningImportLabel: UILabel!
    
    @IBOutlet weak var ErrorImportLabel: UILabel!
    
    @IBOutlet weak var editingTextView: UITextView!
    
    var warnings = 0
    var errors = 0
    var successes = 0
    
    var eventsForPreview: [MainEvent] = []
    
    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editingTextView.delegate = self
        // Do any additional setup after loading the view.
        paintText(self.editingTextView)
        updateTextCounters()
        // MARK: - Keyboard dismissing
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    
    
    
    @IBAction func previewPressed(_ sender: UIBarButtonItem) {
        let addEvScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddEventsScreen") as! AddEventScreen
        
        // add imported events
        addEvScreen.updateEventsSafe(events: self.eventsForPreview)
        
        // save date
        addEvScreen.bulkDelegate = {eventList in
            // loaded events + new
            
            let loadedEvents = MainEventStorage.load()
            var resultEvents : [MainEvent] = []
            for ev in loadedEvents + eventList {
                if !resultEvents.contains(where: {$0.id == ev.id}) {
                    resultEvents.append(ev)
                }
            }
            MainEventStorage.save(resultEvents)
            AnalyticsManager.shared.logEvent(eventType: .manualImport)
        }
        
        
        
        self.present(addEvScreen, animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        paintText(textView)
    }
    
    private func resetEventsForPreview(){
        self.eventsForPreview = []
    }
    
    private func resetCounters(){
        warnings = 0
        errors = 0
        successes = 0
        self.resetEventsForPreview()
    }
    
    private func updateTextCounters(){
        self.readyToImportLabel.text = "\(successes) ready to import"
        self.warningImportLabel.text = "\(warnings) has issues"
        self.ErrorImportLabel.text = "\(errors) not converted"
    }
    
    func paintText(_ textView: UITextView) {
        let components = textView.text.components(separatedBy: "\n")
        resetCounters()
        for (index,component) in components.enumerated() {
            if component == "" {
                continue
            }
            let converter = RuleConverterV1(raw: component)
            converter.convert(line: index,statusCallback: {status, line in
                NSLog(status.rawValue)
                NSLog(converter.event.title)
                NSLog(converter.event.eventDate.formatted())
                DispatchQueue.main.async {
                    switch status {
                        
                    case .eventConverted:
                        self.editingTextView.setTextColorForLine(line: line, color: .label)
                        NSLog("index \(line) color label")
                        self.successes += 1
                    case .eventUnknownError:
                        self.editingTextView.setTextColorForLine(line: line, color: .systemRed)
                        self.errors += 1
                        NSLog("index \(line) color red")
                        
                        
                    case .dateNotConverted:
                        self.editingTextView.setTextColorForLine(line: line, color: .systemRed)
                        self.errors += 1
                        NSLog("index \(line) color red")
                        
                        
                    case .nameNotConverted:
                        self.editingTextView.setTextColorForLine(line: line, color: .systemOrange)
                        self.warnings += 1
                        NSLog("index \(line) color orange")
                        
                        
                    case .missedElement:
                        self.editingTextView.setTextColorForLine(line: line, color: .systemOrange)
                        self.warnings += 1
                        NSLog("index \(line) color orange")
                        
                    }
                    self.updateTextCounters()
                    if !self.eventsForPreview.contains(converter.event){
                        self.eventsForPreview.append(converter.event)
                    }
                }
            })
        }
        NSLog("detected")
        if textView.text.count == 0 {
            self.resetCounters()
            self.updateTextCounters()
        }
        
    }
    
}

extension UITextView {
    func setTextColorForLine(line lineIndex: Int, color: UIColor) {
        guard let text = self.text else { return }
        // Split the text into lines
        let lines = text.components(separatedBy: "\n")
        let line = lines[lineIndex]
        
        var location = 0
        
        for l in lines {
            if l != line {
                location += l.count
                // adding \n of every line
                if lines.count > 1{
                    location += 1
                }
            } else {
                break
            }
            
        }
        
        var lineRange = (line as NSString).localizedStandardRange(of: line)
        lineRange.location = location
        
        textStorage.addAttribute(.foregroundColor, value: color, range: NSRange(location: lineRange.location, length: line.count))
    }
}



