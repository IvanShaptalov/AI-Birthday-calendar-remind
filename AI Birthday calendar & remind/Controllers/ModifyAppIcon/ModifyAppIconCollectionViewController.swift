//
//  ModifyAppIconCollectionViewController.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 09.05.2024.
//

import UIKit

private let collectionViewCellReuseIdentifier = "collectionViewCellReuseIdentifier"

class ModifyAppIconCollectionViewController: UICollectionViewController {

    // MARK: - viewDidLoad ⚙️
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellReuseIdentifier)

        
        // MARK: - Dismiss button 
        var button = XdismissButton.get()
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        XdismissButton.layoutToRightCorner(button: &button, parentView: &self.view)
    }
 

    @objc func buttonAction(sender: UIButton!) {
        self.dismiss(animated: true)
    }

   

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return AppConfiguration.appIconsNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseIdentifier, for: indexPath)
    
        // Create an image view
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 100, height: 100))
        
        imageView.image = UIImage(named: AppConfiguration.appIconsNames[indexPath.row])
                
        view.backgroundColor = .white

        
        view.addSubview(imageView)
        
        
        view.layer.cornerRadius = 12
        
        cell.addSubview(view)
            
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !MonetizationConfiguration.isPremiumAccount {
            AnalyticsManager.shared.logEvent(eventType: .tryIconChange)
            SubscriptionProposer.forceProVersionPaywall(viewController: self)
        } else {
            AppIconChanger.changeIcon(name: AppConfiguration.appIconsNames[indexPath.row])
            { error  in
                if error != nil {
                    let alert = UIAlertController(title: "Icon Modifying", message: error!.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(.init(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
