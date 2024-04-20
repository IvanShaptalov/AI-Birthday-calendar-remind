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
    
    // MARK: - Fields 🌾
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
    
    
    // MARK: - Awake from nib ⚙️
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pseudoContent.layer.cornerRadius = 15
        self.setUpCell()
        // Initialization code
    }
    
    
    // MARK: - Set season ☀️❄️
    func setBackgroundBySeason(season: Season, isBlocked: Bool){
        NSLog("season: \(season)")
        let autumnC = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 0.33)
        let winterC = #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 0.33)
        let springC = #colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 0.33)
        let summerC = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 0.4)
        let blockC = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.5)
        
        if isBlocked {
            self.pseudoContent.backgroundColor = blockC
            return
        }

        switch season {
            
        case .Winter:
            self.pseudoContent.backgroundColor = winterC
            
        case .SpringSeason:
            self.pseudoContent.backgroundColor = springC

        case .Summer:
            self.pseudoContent.backgroundColor = summerC

        case .Autumn:
            self.pseudoContent.backgroundColor = autumnC
        }
    }
    
    // MARK: - set Up Dates ⚙️
    private func setUpDates(){
        guard event != nil else {
            return
        }
        let df = DateEventFormatter(date: event!.eventDate)
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
        setUpDates()
    }
    
    // MARK: - Update Image 🌅
    func updateImage(isBlocked: Bool){
        guard event != nil else {
            return
        }
        
        if isBlocked {
            self.eventImage.image = UIImage(systemName: "lock.circle")?.withRenderingMode(.alwaysTemplate).applyingSymbolConfiguration(.init(paletteColors: [#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 0.9019557119)]))
            return
        }
        
        switch self.event!.eventType {
            
        case .birthday:
            
            self.eventImage.image = UIImage(systemName: self.event!.getImageSystemName(eventType: self.event!.eventType))?.withRenderingMode(.alwaysTemplate).applyingSymbolConfiguration(.init(paletteColors: [#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 0.9089921358)]))
            
            
        case .anniversary:
            
            self.eventImage.image = .init(systemName: self.event!.getImageSystemName(eventType: self.event!.eventType))?.withRenderingMode(.alwaysTemplate).applyingSymbolConfiguration(.init(paletteColors: [#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 0.9)]))
            
        case .simpleEvent:
            self.eventImage.image = .init(systemName: self.event!.getImageSystemName(eventType: self.event!.eventType))?.withRenderingMode(.alwaysTemplate).applyingSymbolConfiguration(.init(paletteColors: [#colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 0.9)]))
            
        }
    }
}
