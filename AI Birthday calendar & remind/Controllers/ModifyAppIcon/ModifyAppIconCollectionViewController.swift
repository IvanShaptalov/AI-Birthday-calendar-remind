//
//  ModifyAppIconCollectionViewController.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 09.05.2024.
//

import UIKit

private let collectionViewCellReuseIdentifier = "collectionViewCellReuseIdentifier"

class ModifyAppIconCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellReuseIdentifier)

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
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 110, height: 110)) // Adjust the frame as per your requirement
        imageView.image = UIImage(named: AppConfiguration.appIconsNames[indexPath.row]) // Replace "yourImageName" with the name of your image asset
        
        // Add the image view as a subview to the cell
        
        cell.addSubview(imageView)
        
        cell.layer.cornerRadius = 12
    
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
