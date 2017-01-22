//
//  ContactPickerViewController.swift
//  ContactPerformance
//
//  Created by Bryan Irace on 8/31/16.
//  Copyright © 2016 Bryan Irace. All rights reserved.
//

import Contacts
import UIKit

protocol ContactSinglePickerViewControllerDelegate: class {
    func contactPicker(picker: ContactSinglePickerViewController, didSelectContact contact: CNContact)
    
    func contactPickerDidCancel(picker: ContactSinglePickerViewController)
}

/**
 Differences from `CNContactPickerViewController:`
 
 - Search bar scrolls with the table view because `UISearchController` is a piece of garbage that I can’t get to work otherwise.
 */
final class ContactSinglePickerViewController: UITableViewController {
    // MARK: - Search
    
    private lazy var searchResultsController: ContactPickerSearchResultsViewController = ContactPickerSearchResultsViewController(delegate: self)
    
    private lazy var searchController: UISearchController = UISearchController(searchResultsController: self.searchResultsController)

    // MARK: - Mutable state
    
    private let cache = ContactCache()

    // MARK: - Inputs
    
    private weak var delegate: ContactSinglePickerViewControllerDelegate?
    
    // MARK: - Initialization
    
    init(delegate: ContactSinglePickerViewControllerDelegate) {
        self.delegate = delegate
        
        super.init(style: .Plain)
        
        title = "All Contacts"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = ContactTableViewCell.rowHeight
        tableView.tableHeaderView = searchController.searchBar
        tableView.registerClass(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier)
        
        ContactReader.all({ (contacts) in
            self.cache.update(contacts)
            
            self.tableView.reloadData()
        })
        
        searchController.searchResultsUpdater = self
        
        // Required with opaque navigation bars
        navigationController?.extendedLayoutIncludesOpaqueBars = true
    }
    
    // MARK: - Actions
    
    private dynamic func cancelButtonTapped() {
        delegate?.contactPickerDidCancel(self)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cache.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ContactTableViewCell.reuseIdentifier, forIndexPath: indexPath) as! ContactTableViewCell
        cell.setContact(cache[indexPath.row])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        readFullContactFromStoreAndInvokeDelegate(contact: cache[indexPath.row])
    }
    
    // MARK: - Private
    
    private func readFullContactFromStoreAndInvokeDelegate(contact contact: CNContact) {
        // TODO: Where to handle lack of phone number or email address?
        
        self.delegate?.contactPicker(self, didSelectContact: ContactReader.contactWithPhoneNumbersAndEmailAddresses(fromContact: contact))
    }
}

// MARK: - UISearchResultsUpdating

extension ContactSinglePickerViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let query = searchController.searchBar.text where !query.isEmpty else { return }

        searchResultsController.contacts = cache.search(query)
    }
}

// MARK: - FriendsListSearchResultsViewControllerDelegate

extension ContactSinglePickerViewController: ContactPickerSearchResultsViewControllerDelegate {
    func contactPicker(picker: ContactPickerSearchResultsViewController, didSelectContact contact: CNContact) {
        readFullContactFromStoreAndInvokeDelegate(contact: contact)
    }
}
