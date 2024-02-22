//
//  AddEventCell.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 22.02.2024.
//

import UIKit

class AddEventCell: UITableViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventDate: UIDatePicker!
    
    @IBOutlet weak var eventType: UISegmentedControl!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    var eventDelegate: ((MainEvent) -> Void)?
    
    @IBOutlet weak var pseudoView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pseudoView.layer.cornerRadius = 15
        self.selectionStyle = .none
        
        self.updateImage()
        self.setUpDateFormat()
        // Initialization code
    }
    
    var mainEvent = MainEvent(eventType: .birthday)
    
    private func editEvent() {
        var eventType: EventTypeEnum?
        
        switch self.eventType.selectedSegmentIndex{
        case 0:
            eventType = .birthday
        case 1:
            eventType = .anniversary
        case 2:
            eventType = .simpleEvent
        default:
            eventType = .birthday
        }
        
        let evDate = self.eventDate.date
        self.mainEvent.eventDate = evDate
        self.mainEvent.eventType = eventType!
        self.mainEvent.title = titleTextField.text ?? ""
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        editEvent()
        NSLog("Editing changed")
        eventDelegate?(self.mainEvent)
    }
    
    private func setUpDateFormat() {
        switch self.mainEvent.eventType {
            
        case .birthday:
            self.eventDate.datePickerMode = .date
        case .anniversary:
            self.eventDate.datePickerMode = .date
        case .simpleEvent:
            self.eventDate.datePickerMode = .dateAndTime
        }
    }
    
    private func updateImage(){
        switch self.mainEvent.eventType {
            
        case .birthday:
            
            self.eventImage.image = UIImage(systemName: self.mainEvent.getImageSystemName(eventType: self.mainEvent.eventType))?.withRenderingMode(.alwaysTemplate).applyingSymbolConfiguration(.init(paletteColors: [.systemBlue]))
            
            
        case .anniversary:
            
            self.eventImage.image = .init(systemName: self.mainEvent.getImageSystemName(eventType: self.mainEvent.eventType))?.withRenderingMode(.alwaysTemplate).applyingSymbolConfiguration(.init(paletteColors: [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)]))
            
        case .simpleEvent:
            self.eventImage.image = .init(systemName: self.mainEvent.getImageSystemName(eventType: self.mainEvent.eventType))?.withRenderingMode(.alwaysTemplate).applyingSymbolConfiguration(.init(paletteColors: [#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)]))
            
        }
        
        
        
    }
    
    @IBAction func anniversaryTypeChanged(_ sender: UISegmentedControl) {
        editEvent()
        NSLog("Editing changed")
        
        updateImage()
        setUpDateFormat()
        eventDelegate?(self.mainEvent)
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        editEvent()
        NSLog("Editing changed")
        eventDelegate?(self.mainEvent)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
