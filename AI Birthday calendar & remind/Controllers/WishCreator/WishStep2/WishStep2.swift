//
//  WishCreatorStep2.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 07.03.2024.
//

import UIKit



class WishCreatorStep2: UIViewController {
    // MARK: - Fields 🌾
    var viewModel: WishStep2ViewModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var whoWish: UIButton!
    
    @IBOutlet weak var messageStyle: UIButton!
    
    @IBOutlet weak var messageStyleOpt: UITextField!
    
    @IBOutlet weak var receiverOpt: UITextField!
    
    @IBOutlet weak var ageCelebrator: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    deinit {
        NSLog("Free WishStep 2 🥦")
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()
        guard viewModel != nil else {
            fatalError("view model not initialized")
        }
        self.setupTitleText()
        self.setUpWhoCelebrating()
        self.setUpMessageStyle()
        self.setupDissmissKeyboardTap()
    }
    
    // MARK: - Set Up ⚙️
    private func setUpMessageStyle(){
        MessageStylePopupButton.setWhoWish(button: &self.messageStyle,
                                           menuClosure: { [unowned self] action in
            
            self.viewModel!.setupMessageStyle(action.title)
        })
    }
    
    private func setUpWhoCelebrating(){
        WhoWishPopupButton.setWhoWish(button: &whoWish,
                                      values: WhoWish.allValuesCorrespondingTo(wish: self.viewModel!.wish!),
                                      menuClosure: { [unowned self] action in
            
            self.viewModel!.setupToWhoWish(action.title)
        })
        
        self.nameField.text = viewModel?.celebratorTitle
        
        self.ageCelebrator.text = viewModel?.yearTurns
    }
    
    private func setupTitleText() {
        titleLabel.text = viewModel?.wish?.rawValue ?? "Create Wish"
    }
    
    private func setupDissmissKeyboardTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard(){
        view.endEditing(true)
    }
}

// MARK: - Ext Animations
extension WishCreatorStep2 {
    private func startLoadingButtonAnimation (_ button: UIButton) {
        // show loading animation on button
        DispatchQueue.main.async { [weak self] in
            button.configuration?.showsActivityIndicator = true
            self?.viewModel!.buttonDisabled = true
        }
        
    }
    
    private func stopLoadingButtonAnimation (_ button: UIButton) {
        DispatchQueue.main.async { [weak self] in
            button.configuration?.showsActivityIndicator = false
            self?.viewModel!.buttonDisabled = false
        }
    }
}

// MARK: - Generate Wish 😘
extension WishCreatorStep2 {
    @IBAction func generateWish(_ sender: UIButton) {
        
        // wishMaker will be nil if request already sent to server (flood protect =) )
        guard let wishMaker = viewModel!.prepareFieldsToMakeWish(optionalReceiver: receiverOpt.text,
                                                                 optionalMessageStyle: messageStyleOpt.text,
                                                                 optionalAgeCelebrator: ageCelebrator.text,
                                                                 optionalNameField: nameField.text) else {
            return
        }
        
        // start loading
        startLoadingButtonAnimation(sender)
        
        wishMaker.sendRequest(callback: { [weak self]
            responseText in
            
            // handle success result
            self?.stopLoadingButtonAnimation(sender)
            
            self?.processResultToFinishStep(responseText: responseText)
            
        }, error: { [weak self] errorText in
            
            // handle failure
            self?.stopLoadingButtonAnimation(sender)
            
            self?.processErrorResult(errorText)
            
            AnalyticsManager.shared.logEvent(eventType: .wishNotGenerated)
        }
        )
    }
    
    private func processResultToFinishStep(responseText: String) {
        DispatchQueue.main.async {
            NSLog("⛑️: \(responseText)")
            
            AnalyticsManager.shared.logEvent(eventType: .wishStartGenerating)
            
            
            var finish = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WishCreateFinish") as! WishResultTransferProtocol
            
            finish.wishResult = responseText
            
            self.present(finish as! UIViewController, animated: true)
        }
    }
    
    private func processErrorResult(_ textError: String) {
        NSLog("🧨 error in response: \(textError)")
        if textError.lowercased().contains("limit") {
            let alertController = UIAlertController(title: "Day limit reached", message: "", preferredStyle: .alert)
            
            alertController.addAction(.init(title: "OK", style: .default))
            DispatchQueue.main.async {
                self.present(alertController, animated: true)
                
            }
        }
    }
}
