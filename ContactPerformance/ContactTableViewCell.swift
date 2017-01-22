//
//  ContactTableViewCell.swift
//  ContactPerformance
//
//  Created by Bryan Irace on 8/31/16.
//  Copyright © 2016 Bryan Irace. All rights reserved.
//

import Contacts
import UIKit

/**
 Differences from `CNContactPickerViewController:`
 
 - Last names are not bolded (doing so would require custom (ostensibly localized) full name formatting
 */
final class ContactTableViewCell: UITableViewCell {
    static let rowHeight: CGFloat = 44
    static let reuseIdentifier = "ContactTableViewCell"

    override var selected: Bool {
        didSet {
            print("selected: \(selected)")
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        accessoryType = {
            if selected {
                return .Checkmark
            }
            else {
                return .None
            }
        }()
        
        print("selected: \(selected), animated: \(animated)")
    }
    
    func setContact(contact: CNContact) {
        textLabel?.attributedText = CNContactFormatter.attributedStringFromContact(
            contact,
            style: .FullName,
            defaultAttributes: nil
        )
    }
}
