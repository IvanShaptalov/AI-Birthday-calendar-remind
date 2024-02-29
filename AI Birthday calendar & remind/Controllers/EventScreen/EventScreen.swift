//
//  BirthdaysScreen.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 21.02.2024.
//

import UIKit
let reuseIdentifier = "EventCell"
var dontShowNotificationDisabled = false
class BirthdaysScreen: UIViewController{
    
    var mainEvents: [MainEvent] = MainEventStorage.load() {
        didSet {
            NSLog("mainEvents > save to storage")
            mainEvents.sort{DateFormatterWrapper.yearToCurrentInEvent($0)  < DateFormatterWrapper.yearToCurrentInEvent($1)}
            // reschedule notifications
            mainEvents.forEach({$0.setUpNotificationIds()})
            NSLog("😎 check notification possibility")
            if !mainEvents.isEmpty{
                NotificationServiceProvider.scheduleEvent(event: mainEvents.first!, notifDisabled: {
                    if dontShowNotificationDisabled {
                        return
                    }
                    NSLog("🔕, send info that notification disabled")
                    let alertController = UIAlertController(title: "Enable notifications", message: "Go to settings & privacy to re-enable AI Birthday notifications", preferredStyle: .alert)
                    
                    alertController.addAction(.init(title: "OK", style: .default))
                    alertController.addAction(.init(title: "Don't show again for this time", style: .default, handler: {action in
                        dontShowNotificationDisabled = true
                    }))
                    
                    self.present(alertController, animated: true)
                    
                })
            }
            NotificationServiceProvider.cancelAllNotifications()
            mainEvents.forEach({NotificationServiceProvider.scheduleEvent(event: $0, notifDisabled: nil)})
            MainEventStorage.save(mainEvents)
        }
    }
    
    @IBOutlet weak var tableEvents: UITableView!
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        mainEvents.sort{DateFormatterWrapper.yearToCurrentInEvent($0)  < DateFormatterWrapper.yearToCurrentInEvent($1)}
        self.tableEvents.register(.init(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    
    
    // MARK: - Edit button
    var isEditingEvents = false
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        isEditingEvents = !isEditingEvents
        if isEditingEvents {
            
            sender.image = .init(systemName: "checkmark.circle")
            
        } else {
            
            sender.image = .init(systemName: "pencil")
            
        }
        self.tableEvents.setEditing(isEditingEvents, animated: true)
    }
    
    // MARK: - Add button
    
    @IBAction func addEventPressed(_ sender: Any) {
        
    }
    
}

extension BirthdaysScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainEvents.count
    }
    
    // MARK: - Configure cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventCell
        let i = indexPath.row
        let mEvent = self.mainEvents[i]
        
        cell.event = mEvent
//        cell.title.text = mEvent.title
//        let df = DateFormatterWrapper(date: mEvent.eventDate)
//        
//        cell.dayAndMonth.text = df.monthAndDay()
//        cell.dayOfWeekCalendarFormat.text = df.dayOfWeekCalendarFormat()
//        cell.timeLeft.text = df.timeLeftInDays()
        
        return cell
    }
    
    
}

// MARK: - event selected
extension BirthdaysScreen {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editPage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditEventScreen") as! EditEventScreen
        // MARK: - EDITING
        editPage.bulkDelegate = {eventList in
            guard let ev = eventList.first else {
                return
            }
            self.mainEvents[indexPath.row] = ev
            self.tableEvents.reloadData()
        }
        
        editPage.events = [self.mainEvents[indexPath.row]]
        
        self.present(editPage, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
    
    
    // MARK: - trailing swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actions = UISwipeActionsConfiguration(actions:getActions(indexPath: indexPath))
        return actions
        
    }
    
    // MARK: - leading swipe
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = UISwipeActionsConfiguration(actions:getActions(indexPath: indexPath))
        return actions
    }
    
    // MARK: - DELETE EVENT
    private func getActions(indexPath: IndexPath) -> [UIContextualAction]{
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { _,_,_ in
            // remove notifications firstly
            NotificationServiceProvider.cancelNotifications(ids: self.mainEvents[indexPath.row].getNotificationIds())
            self.mainEvents.remove(at: indexPath.row)
            self.tableEvents.deleteRows(at: [indexPath], with: .automatic)
        }
        
        actionDelete.backgroundColor = .systemBackground
        var img: UIImage = UIImage(systemName: "trash.fill")!.withRenderingMode(.alwaysOriginal)
        
        img = img.withTintColor(.red)
        
        actionDelete.image = img
        
        return [actionDelete]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bulkAddEvent" {
            var destination = segue.destination as! MainEventBulkCreatingProtocol
            
            
            // MARK: - Word saving via delegate
            destination.bulkDelegate = { [unowned self] eventList in
                self.mainEvents.append(contentsOf: eventList)
                self.tableEvents.reloadData()
                RateProvider.rateAppImplicit(view: self.view)
            }
        }
    }
}
