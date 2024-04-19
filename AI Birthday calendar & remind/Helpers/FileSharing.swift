//
//  FileSharing.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 19.04.2024.
//

import Foundation
import UIKit


class FileSharing {
    static func share(viewController: UIViewController, fileURL: URL){
        var filesToShare = [Any]()
                
        // Add the path of the file to the Array
        filesToShare.append(fileURL)
                
        // Make the activityViewContoller which shows the share-view
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)

        // Be notified of the result when the share sheet is dismissed
        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            
        }

        // Show the share-view
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    static func getDocumentsDirectory(fileName: String) -> URL? {
        var url: URL?
        if #available(iOS 16.0, *) {
            url = URL.documentsDirectory.appending(path: fileName)
            
            
        } else {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            url = paths.first
            
            url = url?.appendingPathComponent(fileName, isDirectory: false)
        }
        return url
    }
}
