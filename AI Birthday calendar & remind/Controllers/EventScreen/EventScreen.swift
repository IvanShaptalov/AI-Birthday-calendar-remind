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
            NotificationServiceProvider.cancelAllNotifications()

//            oldValue
            NSLog("mainEvents > save to storage")
            mainEvents.sort{DateEventFormatter.yearToCurrentInEvent($0)  < DateEventFormatter.yearToCurrentInEvent($1)}
            // reschedule notifications
            mainEvents.forEach({$0.setUpNotificationIds()})
            NSLog("😎 check notification possibility")
            if !mainEvents.isEmpty{
                NotificationServiceProvider.scheduleEvent(event: mainEvents.first!, notifDisabled: {
                    if dontShowNotificationDisabled {
                        return
                    }
                    NSLog("🔕, send info that notification disabled")
                    if AppConfiguration.isLaunchedEarlier {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Are You enabled notifications 😏?", message: "Go to settings & privacy to re-enable AI Birthday notifications", preferredStyle: .alert)
                            
                            alertController.addAction(.init(title: "Done", style: .default))
                            alertController.addAction(.init(title: "Don't show again for this time", style: .default, handler: {action in
                                dontShowNotificationDisabled = true
                            }))
                            
                            self.present(alertController, animated: true)
                        }
                    }
                    
                })
            }
            for (index, event) in mainEvents.enumerated() {
                NSLog("✨ event to notify: \(event.title)")
                if isNeedToNotify(index: index){
                    NotificationServiceProvider.scheduleEvent(event: event, notifDisabled: nil)
                }
            }
            MainEventStorage.save(mainEvents)
        }
    }
    
    /// set notification to first free events if is not premium account
    private func isNeedToNotify(index i: Int) -> Bool {
        if MonetizationConfiguration.isPremiumAccount {
            NSLog("⏰ is premium account - need to notify")
            return true
        } else {
            NSLog("⏰ is not premium, i = \(i), free events: \(MonetizationConfiguration.freeEventRecords) notify next? : \(i < MonetizationConfiguration.freeEventRecords)")
            return i < MonetizationConfiguration.freeEventRecords
        }
    }
    
    // MARK: - Fields for Multiple Selection 🌾
    
    @IBOutlet weak var premiumBadge: UIBarButtonItem!
    
    @IBOutlet weak var upToolbar: UIToolbar!
    
    var toolbarItemsDefault: [UIBarButtonItem]?
    
    // MARK: - Talbe 📜
    @IBOutlet weak var tableEvents: UITableView!
    
    
    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()
        if TutorialProvider.isAwailableToAddCards(){
            mainEvents += TutorialProvider.getCards()
        }
        
        self.setUpPremiumBadge()

        mainEvents.sort{DateEventFormatter.yearToCurrentInEvent($0)  < DateEventFormatter.yearToCurrentInEvent($1)}
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
    
    // MARK: - viewDidAppear ⚙️
    override func viewDidAppear(_ animated: Bool) {
        self.mainEvents = MainEventStorage.load()
        self.tableEvents.reloadData()
        self.setUpPremiumBadge()
        NSLog("updated from viewDidAppear \(mainEvents.count)")
        //        self.proposePremiumAtStart()
    }
    
    // MARK: - Premium badge
    func setUpPremiumBadge(){
        if #available(iOS 16.0, *) {
            premiumBadge.isHidden = !MonetizationConfiguration.isPremiumAccount
        } else {
            if !MonetizationConfiguration.isPremiumAccount {
                self.toolbarItems?.removeAll(where: {$0 == premiumBadge})
                self.toolbarItemsDefault?.removeAll(where: {$0 == premiumBadge})
            }
        }
    }
    
    // MARK: - Add Events Button ➕
    @IBAction func addEventPressed(_ sender: Any) {
       
            var addEvScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddEventsScreen") as! MainEventBulkCreatingProtocol
            
            // MARK: - Word saving via delegate
            addEvScreen.bulkDelegate = { [unowned self] eventList in
                self.mainEvents.append(contentsOf: eventList)
                self.tableEvents.reloadData()
            }
            
            
            
            self.present(addEvScreen as! UIViewController, animated: true)
        
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
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.systemBackground
        cell.selectedBackgroundView = bgColorView
        
        
        cell.event = mEvent
        
        
        
        cell.setBackgroundBySeason(season: EventSeasonController.getSeason(mEvent.eventDate), isBlocked: isCellBlocked(index: i))
        cell.updateImage(isBlocked: isCellBlocked(index: i))
        return cell
    }
    
    private func isCellBlocked(index i: Int) -> Bool{
        // blocked if run off free events and account not premium
        let isBlocked = i >= MonetizationConfiguration.freeEventRecords && !MonetizationConfiguration.isPremiumAccount
        return isBlocked
    }
}

// MARK: - Event Selection **EXT ✨
extension BirthdaysScreen {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            return
        }
        
        if isCellBlocked(index: indexPath.row){
            AnalyticsManager.shared.logEvent(eventType: .blockCellSelected)
            SubscriptionProposer.forceProVersionRecordsLimited(viewController: self)
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
        let fixedFlex = UIBarButtonItem.fixedSpace(10)
        let selectAll = UIBarButtonItem(image: UIImage(systemName: "checklist")?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(selectAllItems))
        
        let deleteButton = UIBarButtonItem(image: .init(systemName: "trash")?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(removeSelectedItems))
        
        let shareButton = UIBarButtonItem(image: .init(systemName: "square.and.arrow.up")?.withTintColor(.systemIndigo,renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(shareSelected))
        
        let done = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle")?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(setUpEditingDone))
        return [done,fixedFlex, deleteButton,flex, shareButton, fixedFlex, selectAll]
    }
    
    @objc func setUpEditingDone() {
        self.upToolbar.setItems(toolbarItemsDefault, animated: true)
        self.tableEvents.setEditing(false, animated: true)
    }
    
    @objc func shareSelected() {
        let selectedIndexes = self.tableEvents.indexPathsForSelectedRows
        
        if (selectedIndexes == nil || selectedIndexes!.isEmpty)  {
            let alertController = UIAlertController(title: "No selection", message: "Select some events to delete", preferredStyle: .alert)
            
            alertController.addAction(.init(title: "Ok", style: .cancel))
            self.present(alertController, animated: true)
            
        } else {
            self.shareSelectedWords(selectedWordsIndexes: selectedIndexes?.map({$0.item}) ?? [])
        }
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
    
    // MARK: - Function for bulk actions 🤖
    private func removeSelectedWords(selectedWords: [Int]) {
        self.mainEvents = self.mainEvents
            .enumerated()
            .filter { !selectedWords.contains($0.offset) }
            .map { $0.element }
        self.tableEvents.reloadData()
        
    }
    
    private func shareSelectedWords(selectedWordsIndexes: [Int]) {
        
        let wordsToShare = self.mainEvents.enumerated().filter {selectedWordsIndexes.contains($0.offset)}.map{$0.element}
        
        let shareScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WordsToShareScreen") as! ShareScreen
        
        shareScreen.events = wordsToShare
        
        self.present(shareScreen, animated: true)
        
    }
}
