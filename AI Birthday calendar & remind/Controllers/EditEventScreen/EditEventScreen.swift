//
//  AddEventScreen.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 22.02.2024.
//

import UIKit

let reuseIdentifierEditEventCell = "EditEventCell"

protocol MainEventEditProtocol{
    var events: [MainEvent] {get set}
}


class EditEventScreen: UIViewController, MainEventBulkCreatingProtocol, MainEventEditProtocol {
    // MARK: - Delegates 🐪
    var bulkDelegate: (([MainEvent]) -> Void)?
    
    // MARK: - Fields 🌾
    var events: [MainEvent] = []
    @IBOutlet weak var tableViewAddEvents: UITableView!

    
    
    
    // MARK: - Make wish 🪄
    @IBAction func makeWishTapped(_ sender: UIBarButtonItem) {
        
        
        
        
        var wishType = WishType.bday
        
        guard let event = events.first else {
            return
        }
    
        switch event.eventType {
            
        case .birthday:
            wishType = WishType.bday
        case .anniversary:
            wishType = .anniversary
        case .simpleEvent:
            let generatorStep1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WishCreatorStep1") as! WishCreatorTableViewController
            self.present(generatorStep1, animated:  true)
        }
        
        let generatorStep2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WishCreatorStep2") as! WishCreatorStep2
        
        generatorStep2.wish = wishType
        generatorStep2.celebratorTitle = event.title
        
        let yearTurns = DateEventFormatter(date: event.eventDate).yearsTurns()
       
        generatorStep2.yearTurns = "\(yearTurns) years old"
       
        
        self.present(generatorStep2, animated: true)
    }
    
    // MARK: - Bulk edit
    @IBAction func bulkEdit(_ sender: UIBarButtonItem) {
        var evCopy = self.events
        evCopy.removeAll(where: {$0.title == ""})
        self.bulkDelegate?(evCopy)
        
        evCopy.forEach({ev in
            switch ev.eventType {
                
            case .birthday:
                AnalyticsManager.shared.logEvent(eventType: .birthdayCreated)
            case .anniversary:
                AnalyticsManager.shared.logEvent(eventType: .anniversaryCreated)
            case .simpleEvent:
                AnalyticsManager.shared.logEvent(eventType: .eventCreated)
            }
        }
        )
        
        self.dismiss(animated: true)
        
        
    }
    
    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewAddEvents?.register(.init(nibName: "AddEventCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierAddEventCell)
        self.tableViewAddEvents?.reloadData()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
}

// MARK: - Datasource **EXT ✨
extension EditEventScreen: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("Edit screen: events count \(events.count)")
        
        return events.count
    }
    
    // MARK: - Configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierAddEventCell, for: indexPath) as! AddEventCell
        // reset reused cell
        let mEvent = events[indexPath.row]
        cell.mainEvent = mEvent
        cell.titleTextField.text = mEvent.title
        cell.eventDate.date = mEvent.eventDate
        cell.setEventType(eventType: mEvent.eventType)
        cell.setUpDateFormat()
        NSLog("\(indexPath)")
        // update event via delegate in cell
        cell.eventDelegate = {eve in
            self.events[indexPath.row] = eve
        }
        
        return cell
    }
}
