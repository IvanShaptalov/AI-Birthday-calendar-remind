//
//  XdismissButton.swift
//  AI Birthday calendar & remind
//
//  Created by PowerMac on 10.05.2024.
//

import UIKit


class XdismissButton {
    static func get() -> UIButton {
        let button = UIButton.systemButton(with: UIImage(systemName: "xmark.circle")!, target: nil, action: nil)
                
        button.tintColor = .systemIndigo
                
        button.translatesAutoresizingMaskIntoConstraints = false
                
        return button
    }
    
    static func layoutToLeftCorner(button: inout UIButton, parentView: inout UIView) {
        parentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            
            // Top constraint
            button.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: 16), // Adjust the constant as needed
            // Leading constraint
            button.trailingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.trailingAnchor, constant: -16), // Adjust the constant as needed
        ])
    }
    
    static func layoutToRightCorner(button: inout UIButton, parentView: inout UIView) {
        parentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            // Top constraint
            button.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: 16), // Adjust the constant as needed
            // Leading constraint
            button.leadingAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leadingAnchor, constant: 16), // Adjust the constant as needed
            // Set width
            button.widthAnchor.constraint(equalToConstant: 44),
            // Set height
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    
}
