//
//  ContactSearchResultsViewController.swift
//  ContactPerformance
//
//  Created by Bryan Irace on 8/31/16.
//  Copyright © 2016 Bryan Irace. All rights reserved.
//

import Contacts
import UIKit

protocol ContactPickerSearchResultsViewControllerDelegate: class {
    func contactPicker(picker: ContactPickerSearchResultsViewController, didSelectContact contact: CNContact)
}

final class ContactPickerSearchResultsViewController: UITableViewController {
    // MARK: - Mutable state
    
    var contacts: [CNContact] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Inputs
    
    private weak var delegate: ContactPickerSearchResultsViewControllerDelegate?
    
    // MARK: - Initialization
    
    init(delegate: ContactPickerSearchResultsViewControllerDelegate) {
        self.delegate = delegate
        
        super.init(style: .Plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = ContactTableViewCell.rowHeight
        tableView.registerClass(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier)
        
        edgesForExtendedLayout = .None
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ContactTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! ContactTableViewCell
        cell.setContact(contacts[indexPath.row])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.contactPicker(self, didSelectContact: contacts[indexPath.row])
    }
}
