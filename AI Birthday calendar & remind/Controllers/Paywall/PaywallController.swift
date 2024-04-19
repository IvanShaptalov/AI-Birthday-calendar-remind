//
//  PaywallControllerViewController.swift
//  Learn Up
//
//  Created by PowerMac on 05.02.2024.
//

import UIKit

let subReuseIdentifier = "SubscriptionCell"

class PaywallController: UIViewController{
    // MARK: - Fields 🌾
    var selectedSub: SubscriptionObj?
    
    @IBOutlet weak var benefitLabel: UILabel!
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    @IBOutlet weak var subscriptionTableView: UITableView!
    
    var updateDelegate: (() -> Void)?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.updateDelegate?()
    }
    
    var subs: [SubscriptionObj] = RevenueCatProductsProvider.subscriptionList

    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Fetch subs if empty
        if self.subs.isEmpty {
            NSLog("subs is empty, start load")
            RevenueCatProductsProvider.getOffering(subCallback: {subs in
                self.subs = subs
                self.subscriptionTableView.reloadData()
            }, catchError: {error in
                self.subs = []
                self.subscriptionTableView.reloadData()
            })
        }
        
        self.subscriptionTableView.register(.init(nibName: subReuseIdentifier, bundle: nil), forCellReuseIdentifier: subReuseIdentifier)
        // MARK: - Select first sub
        if subs.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            subscriptionTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            selectedSub = self.subs[indexPath.row]
        }
    }
    
    // MARK: - Functions 🤖
    @IBAction func termsOfUseClicked(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: AppConfiguration.termsOfUseURL)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func buySubPressed(_ sender: UIButton) {
        AnalyticsManager.shared.logEvent(eventType: .subscriptionButtonTapped)
        if selectedSub == nil {
            print("select sub plan")
            let alert = UIAlertController(title: "Select plan to continue", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        } else {
            AnalyticsManager.shared.logEvent(eventType: .subContinueWithPlan, parameters: ["plan": selectedSub?.title ?? "nil"])

            RevenueCatProductsProvider.makePurchase(package: selectedSub!.package) { status in
                NSLog("PaywallControllerViewController > buySubscriptionPressed > RevenueCatProductsProvider.makePurchase : \(status.rawValue)")
                if status == .Processing {
                    self.purchaseButton.configuration?.showsActivityIndicator = true
                } else {
                    self.purchaseButton.configuration?.showsActivityIndicator = false
                }
            }
        }
    }
}

// MARK: - PayWall DATASOURCE **EXT ✨
extension PaywallController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subs.count
    }
    
    // MARK: configure cell ⚙️
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: subReuseIdentifier, for: indexPath) as! SubscriptionCell
        let s = subs[indexPath.row]
        let familyShareable = !s.isFamilyShareable
        let isFreeTrial = !s.isFreeTrial
        cell.setSubDuration(priceDuration: s.priceDuration)
                
        cell.setUpFreeTrial(isHidden: isFreeTrial)
        
        cell.setUpFamilySharing(isHidden: familyShareable)
        cell.subTitle.text = s.title
        cell.selectionStyle = .none
        cell.setTotalPrice(s.totalPrice)
        return cell
    }
    
    // MARK: - Row select ⚙️
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        let cell = subs[indexPath.row]
        print(cell.title)
        self.selectedSub = cell
    }
    
    
}

