//
//  EventCell.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 21.02.2024.
//

import UIKit

protocol EventObjToCellProtocol{
    var event: MainEvent? {get set}
}

class EventCell: UITableViewCell, EventObjToCellProtocol {
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var pseudoContent: UIView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var timeLeft: UILabel!
    
    @IBOutlet weak var dayOfWeekCalendarFormat: UILabel!
    
    @IBOutlet weak var dayAndMonth: UILabel!
    
    var event: MainEvent? {
        didSet{
            self.setUpCell()
        }
    }
    
    
    // MARK: - Awake from nib
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.pseudoContent.layer.cornerRadius = 15
        self.setUpCell()
        // Initialization code
    }
    
    
    // MARK: - set Up Dates
    private func setUpDates(){
        guard event != nil else {
            return
        }
        let df = DatePrinter(date: event!.eventDate)
        if event?.eventType == .simpleEvent {
            self.timeLeft.text = df.hourAndMinute()
            self.dayOfWeekCalendarFormat.text = df.dayOfWeekCalendarFormat()
            self.dayAndMonth.text = df.monthAndDay()
        } else {
            self.timeLeft.text = df.yearsTurnsInDays()
            self.dayOfWeekCalendarFormat.text = df.dayOfWeekCalendarFormat()
            self.dayAndMonth.text = df.monthAndDay()
        }
       
    }
    
    // MARK: - setUP Cell
    private func setUpCell(){
        guard event != nil else {
            return
        }
        self.title.text = event?.title
        updateImage()
        setUpDates()
    }
    
    // MARK: - Update Image
    private func updateImage(){
        guard event != nil else {
            return
        }
        
        switch self.event!.eventType {
            
        case .birthday:
            
            self.eventImage.image = UIImage(systemName: self.event!.getImageSystemName(eventType: self.event!.eventType))?.withRenderingMode(.alwaysTemplate).applyingSymbolConfiguration(.init(paletteColors: [.systemBlue]))
            
            
        case .anniversary:
            
            self.eventImage.image = .init(systemName: self.event!.getImageSystemName(eventType: self.event!.eventType))?.withRenderingMode(.alwaysTemplate).applyingSymbolConfiguration(.init(paletteColors: [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)]))
            
        case .simpleEvent:
            self.eventImage.image = .init(systemName: self.event!.getImageSystemName(eventType: self.event!.eventType))?.withRenderingMode(.alwaysTemplate).applyingSymbolConfiguration(.init(paletteColors: [#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)]))
            
        }
        
        
        
    }
    
    // MARK: - Selecting
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    // MARK: - Editing
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//    }
}
