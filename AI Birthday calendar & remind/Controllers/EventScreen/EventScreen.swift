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
    
    // MARK: - Main Events Field 🌾
    var mainEvents: [MainEvent] = MainEventStorage.load() {
        didSet {
            NSLog("mainEvents > save to storage")
            mainEvents.sort{DatePrinter.yearToCurrentInEvent($0)  < DatePrinter.yearToCurrentInEvent($1)}
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
    
    // MARK: - Fields for Multiple Selection 🌾
    
    @IBOutlet weak var upToolbar: UIToolbar!
    
    var toolbarItemsDefault: [UIBarButtonItem]?
        
    
    
    // MARK: - Talbe 📜
    @IBOutlet weak var tableEvents: UITableView!
    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()
        mainEvents.sort{DatePrinter.yearToCurrentInEvent($0)  < DatePrinter.yearToCurrentInEvent($1)}
        self.tableEvents.register(.init(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        DispatchQueue.global().async {
            do {
                _ = try UpdateChecker().isUpdateAvailable(completion: {needUpdate,error  in
                    
                    NSLog("is need update: \(needUpdate ?? false)")
                    if error != nil {
                        NSLog("🤖 error while check update: \(error!)")
                    } else if needUpdate != nil && needUpdate! {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Time for an update", message: "You are using a version that is no longer supported.Please update to the newest version to keep using the app.", preferredStyle: .alert)
                            alertController.addAction(.init(title: "OK", style: .default))
                            
                            
                            self.present(alertController, animated: true)
                        }
                    }
                })
                
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mainEvents = MainEventStorage.load()
        self.tableEvents.reloadData()
        NSLog("updated from viewDidAppear \(mainEvents.count)")
        self.proposePremiumAtStart()
    }
    
    private func proposePremiumAtStart(){
        NSLog("proposePremiumAtStart: isLaunchedEarlier: \(AppConfiguration.isLaunchedEarlier) is premium: \(MonetizationConfiguration.isPremiumAccount) 🪙")
        if AppConfiguration.isLaunchedEarlier{
            return
        }
        
        if MonetizationConfiguration.isPremiumAccount {
            return
        }
        
        SubscriptionProposer.forceProVersionRecordsLimited(viewController: self)
        
        
    }
    
    // MARK: - Add Events Button ➕
    @IBAction func addEventPressed(_ sender: Any) {
        NSLog("is premium account: \(MonetizationConfiguration.isPremiumAccount)")
        NSLog("free account: events: \(self.mainEvents.count), limit  \(MonetizationConfiguration.freeEventRecords)")
        
        if SubscriptionProposer.hasNoLimitInMainScreen(self.mainEvents) {
            
            SubscriptionProposer.proposeProVersionRecordsLimited( viewController: self)
            
        } else {
            var addEvScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddEventsScreen") as! MainEventBulkCreatingProtocol
            
            // MARK: - Word saving via delegate
            addEvScreen.bulkDelegate = { [unowned self] eventList in
                self.mainEvents.append(contentsOf: eventList)
                self.tableEvents.reloadData()
            }
            
            
            
            self.present(addEvScreen as! UIViewController, animated: true)
        }
    }
}

// MARK: - Cell configuring **EXT ✨
extension BirthdaysScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainEvents.count
    }
    
    // MARK: - Configure cell ⚙️
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EventCell
        let i = indexPath.row
        let mEvent = self.mainEvents[i]
        
        cell.selectionStyle = .blue
        cell.backgroundColor = .clear
        
       
        cell.event = mEvent
        
        cell.setBackgroundBySeason(season: EventSeasonController.getSeason(mEvent.eventDate))
        return cell
    }
    
    
}

// MARK: - Event Selection **EXT ✨
extension BirthdaysScreen {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            return
        }
        
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
}

// MARK: - Multiple Selection **EXT ✨
/// select and delete some or all birthdays
extension BirthdaysScreen {
    // MARK: - SetUp
    func setUpToolbarItemsWhileEditing() -> [UIBarButtonItem]{
        let flex = UIBarButtonItem.flexibleSpace()
        let selectAll = UIBarButtonItem(image: UIImage(systemName: "checklist")?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(selectAllItems))
        
        let deleteButton = UIBarButtonItem(image: .init(systemName: "trash")?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(removeSelectedItems))
        
        let done = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle")?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(setUpEditingDone))
        return [done, deleteButton,flex, selectAll]
    }
    
    @objc func setUpEditingDone() {
        self.upToolbar.setItems(toolbarItemsDefault, animated: true)
        self.tableEvents.setEditing(false, animated: true)
    }
    
    private func setUpButtonsToEditing(){
        self.toolbarItemsDefault = self.upToolbar.items
        self.upToolbar.setItems(setUpToolbarItemsWhileEditing(), animated: true)
    }
    
    // MARK: - Buttons of multiple selection
    @objc func removeSelectedItems(){
        let selectedIndexes = self.tableEvents.indexPathsForSelectedRows
        
        if (selectedIndexes == nil || selectedIndexes!.isEmpty)  {
            let alertController = UIAlertController(title: "No selection", message: "Select some events to delete", preferredStyle: .alert)
            
            alertController.addAction(.init(title: "Ok", style: .cancel))
            self.present(alertController, animated: true)

        } else {
            let alertController = UIAlertController(title: "You can't undo this action", message: "Remove these words?", preferredStyle: .alert)
            alertController.addAction(.init(title: "Cancel", style: .cancel))
            
            alertController.addAction(.init(title: "Remove", style: .destructive, handler: {action in
                let selectedIndexes = self.tableEvents.indexPathsForSelectedRows
                            
                self.removeSelectedWords(selectedWords: selectedIndexes?.map({$0.item}) ?? [])
            }))
            
            self.present(alertController, animated: true)
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        self.setUpButtonsToEditing()
        
        self.tableEvents.setEditing(true, animated: true)
    }
    
    @objc func selectAllItems(){
        
        let selected = self.tableEvents.indexPathsForSelectedRows
        
        let totalRows = self.tableEvents.numberOfRows(inSection: 0)
        
        if selected?.count == totalRows {
            for row in 0..<totalRows {
                self.tableEvents.deselectRow(at: .init(item: row, section: 0), animated: false)
            }
            
        } else {
            for row in 0..<totalRows {
                self.tableEvents.selectRow(at: .init(item: row, section: 0), animated: false, scrollPosition: .none)
            }
        }
    }
    
    // MARK: - Function 🤖
    private func removeSelectedWords(selectedWords: [Int]) {
        self.mainEvents = self.mainEvents
            .enumerated()
            .filter { !selectedWords.contains($0.offset) }
            .map { $0.element }
        self.tableEvents.reloadData()

    }
}
