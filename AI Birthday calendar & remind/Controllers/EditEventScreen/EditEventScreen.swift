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
    
    var bulkDelegate: (([MainEvent]) -> Void)?
    
    @IBAction func bulkEdit(_ sender: UIBarButtonItem) {
        var evCopy = self.events
        evCopy.removeAll(where: {$0.title == ""})
        self.bulkDelegate?(evCopy)
        self.dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    var events: [MainEvent] = []
    
    
    @IBOutlet weak var tableViewAddEvents: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewAddEvents?.register(.init(nibName: "AddEventCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierAddEventCell)
        self.tableViewAddEvents?.reloadData()

    }
    
    
    
}

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
        
        cell.titleTextField.text = mEvent.title
        cell.eventDate.date = mEvent.eventDate
        cell.setEventType(eventType: mEvent.eventType)
        NSLog("\(indexPath)")
        // update event via delegate in cell
        cell.eventDelegate = {eve in
            self.events[indexPath.row] = eve
        }
        
        return cell
    }
}
