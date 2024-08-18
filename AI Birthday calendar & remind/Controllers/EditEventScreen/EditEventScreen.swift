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
    
    
    deinit {
        NSLog("🥦 Edit Event deinited")
    }
    
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
        
        let yearTurns = DateEventFormatter(date: event.eventDate).yearsTurns()
        
        let viewModel = WishStep2ViewModel(wish: wishType,
                                           celebratorTitle: event.title,
                                           yearTurns: "\(yearTurns) years old")
        
        generatorStep2.viewModel = viewModel
        
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
    
    @IBAction func dismissModalScreen(_ sender: Any) {
        self.dismiss(animated: true)
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
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierAddEventCell,
                                                 for: indexPath) as! AddEventCell
        // reset reused cell
        let mEvent = events[indexPath.row]
        
        self.configureCell(&cell, event: mEvent, index: indexPath.row)
        
        return cell
    }
    
    private func configureCell(_ cell: inout AddEventCell, event: MainEvent, index: Int) {
        cell.mainEvent = event
        cell.titleTextField.text = event.title
        cell.eventDate.date = event.eventDate
        cell.setEventType(eventType: event.eventType)
        cell.setUpDateFormat()
        NSLog("\(index)")
        // update event via delegate in cell
        cell.eventDelegate = { [weak self] eve in
            self?.events[index] = eve
        }
    }
}
