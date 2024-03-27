//
//  WishCreateFinishViewController.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 07.03.2024.
//

import UIKit

protocol WishResultTransferProtocol {
    var wishResult: String? { get set}
}

class WishCreateFinishViewController: UIViewController, WishResultTransferProtocol {
    // MARK: - Fields 🌾
    var wishResult: String?
    
    @IBOutlet weak var gptTextViewField: UITextView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    
    // MARK: - Functions 🤖
    @IBAction func editButtonPressed(_ sender: Any) {
        if !self.gptTextViewField.isFocused  {
            self.gptTextViewField.becomeFirstResponder()
            self.gptTextViewField.setNeedsFocusUpdate()
        }
    }
    @IBAction func sharePressed(_ sender: Any) {
        let text = gptTextViewField.text
                
                // set up activity view controller
                let textToShare = [ text! ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
                // exclude some activity types from the list (optional)
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
                
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func copyPressed(_ sender: Any) {
        let text = gptTextViewField.text
        
        UIPasteboard.general.string = text
        
        RateProvider.rateAppImplicit(view: self.view)

    }
    
    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gptTextViewField.text = self.wishResult
        DispatchQueue.main.async {
            AnalyticsManager.shared.logEvent(eventType: .wishGenerated)
        }
    }
    
    

}
