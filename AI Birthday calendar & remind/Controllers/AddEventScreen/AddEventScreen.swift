//
//  AddEventScreen.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 22.02.2024.
//

import UIKit

let reuseIdentifierAddEventCell = "AddEventCell"

protocol MainEventBulkCreatingProtocol{
    var bulkDelegate: (([MainEvent]) -> Void)? {get set}
}


class AddEventScreen: UIViewController, MainEventBulkCreatingProtocol {
    var bulkDelegate: (([MainEvent]) -> Void)?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewAddEvents.register(.init(nibName: "AddEventCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierAddEventCell)
    }
    
    func updateEventsSafe(events: [MainEvent]){
        let copy = self.events
        self.events = copy + events
        
        self.tableViewAddEvents?.reloadData()
    }
    
    
    @IBAction func bulkAdd(_ sender: UIBarButtonItem) {
        if SubscriptionProposer.hasNoLimitToRecords(eventsToAdd: self.events ){
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
        } else {
            SubscriptionProposer.proposeProVersionRecordsLimited(viewController: self)
        }
    }
    
    var events: [MainEvent] = [MainEvent(eventType: .birthday)] {
        didSet {
            if events.count >= 2 && events[events.count-2].title == "" && events.last?.title == ""
            {
                let indexPath = [IndexPath(row: events.count - 1, section: 0)]
                events.removeLast()
                self.tableViewAddEvents?.deleteRows(at: indexPath, with: .fade)
            }
            
            if events.last?.title != ""{
                events.append(MainEvent(eventType: .birthday))
                let indexPath = [IndexPath(row: events.count - 1, section: 0)]
                
                self.tableViewAddEvents?.insertRows(at: indexPath, with: .fade)
                self.tableViewAddEvents?.scrollToRow(at: indexPath.first!, at: .bottom, animated: true)
                // check limit
            }
        }
    }
    
    
    
    
    
    
    @IBOutlet weak var tableViewAddEvents: UITableView!
    
    
    
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}

extension AddEventScreen: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    // MARK: - Configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierAddEventCell, for: indexPath) as! AddEventCell
        // reset reused cell
        cell.mainEvent = events[indexPath.row]
        cell.setUpCell()
        NSLog("\(indexPath)")
        // update event via delegate in cell
        cell.eventDelegate = {eve in
            self.events[indexPath.row] = eve
        }
        
        return cell
    }
}
