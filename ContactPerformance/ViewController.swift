//
//  ViewController.swift
//  ContactPerformance
//
//  Created by Bryan Irace on 8/30/16.
//  Copyright © 2016 Bryan Irace. All rights reserved.
//

import UIKit

import ContactsUI
import UIKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleButton = UIButton(type: .System)
        singleButton.setTitle("Present Single Contact Picker", forState: .Normal)
        singleButton.addTarget(self, action: #selector(presentSingleContactPicker), forControlEvents: .TouchUpInside)
        
        let multiButton = UIButton(type: .System)
        multiButton.setTitle("Present Multiple Contact Picker", forState: .Normal)
        multiButton.addTarget(self, action: #selector(presentMultiContactPicker), forControlEvents: .TouchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [singleButton, multiButton])
        stackView.axis = .Vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activateConstraints([
            stackView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            stackView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor),
        ])
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Actions
    
    private dynamic func presentSingleContactPicker() {
        let picker = ContactSinglePickerViewController(delegate: self)
        
        presentViewController(
            UINavigationController(rootViewController: picker),
            animated: true,
            completion: nil
        )
    }
    
    // MARK: - Actions
    
    private dynamic func presentMultiContactPicker() {
        let picker = ContactMultiPickerViewController(delegate: self)
        
        presentViewController(
            UINavigationController(rootViewController: picker),
            animated: true,
            completion: nil
        )
    }
}

extension ViewController: ContactSinglePickerViewControllerDelegate {
    func contactPicker(picker: ContactSinglePickerViewController, didSelectContact contact: CNContact) {
        picker.dismissViewControllerAnimated(true) {
            print("Contact selected!: \(contact)")
        }
    }
    
    func contactPickerDidCancel(picker: ContactSinglePickerViewController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ViewController: ContactMultiPickerViewControllerDelegate {
    func contactPicker(picker: ContactMultiPickerViewController, didSelectContacts contacts: [CNContact]) {
        picker.dismissViewControllerAnimated(true) {
            print("Contacts selected!: \(contacts)")
        }
    }
    
    func contactPickerDidCancel(picker: ContactMultiPickerViewController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
