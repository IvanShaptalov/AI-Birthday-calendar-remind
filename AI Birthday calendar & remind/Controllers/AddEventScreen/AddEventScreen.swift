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
    // MARK: - Delegates 🐪
    var bulkDelegate: (([MainEvent]) -> Void)?
    
    // MARK: - Fields 🌾
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

    
    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewAddEvents.register(.init(nibName: "AddEventCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierAddEventCell)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    // MARK: - Keyboard handling 🎹
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.tableViewAddEvents.contentInset.bottom = keyboardHeight
            self.tableViewAddEvents.verticalScrollIndicatorInsets.bottom = keyboardHeight
        } else {
            self.tableViewAddEvents.contentInset.bottom = 0
            self.tableViewAddEvents.verticalScrollIndicatorInsets.bottom = 0
        }
    }

    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
    
    /// update events without many reacts in didSet funciton in events
    func updateEventsSafe(events: [MainEvent]){
        let copy = self.events
        self.events = copy + events
        
        self.tableViewAddEvents?.reloadData()
    }
    
    // ➕ add button
    @IBAction func bulkAdd(_ sender: UIBarButtonItem) {
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
}

// MARK: - DataSource **EXT ✨
extension AddEventScreen: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    // MARK: - Configure cell ⚙️
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
