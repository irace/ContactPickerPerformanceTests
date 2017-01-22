//
//  ContactMultiPickerViewController.swift
//  ContactPerformance
//
//  Created by Bryan Irace on 8/31/16.
//  Copyright © 2016 Bryan Irace. All rights reserved.
//

import Contacts
import UIKit

protocol ContactMultiPickerViewControllerDelegate: class {
    func contactPicker(picker: ContactMultiPickerViewController, didSelectContacts contacts: [CNContact])
    
    func contactPickerDidCancel(picker: ContactMultiPickerViewController)
}

final class ContactMultiPickerViewController: UITableViewController {
    private lazy var searchResultsController: ContactPickerSearchResultsViewController = ContactPickerSearchResultsViewController(delegate: self)
    
    private lazy var searchController: UISearchController = UISearchController(searchResultsController: self.searchResultsController)
    
    private let cache = ContactCache()
    
    private weak var delegate: ContactMultiPickerViewControllerDelegate?
    
    // MARK: - Initialization
    
    init(delegate: ContactMultiPickerViewControllerDelegate) {
        self.delegate = delegate
        
        super.init(style: .Plain)
        
        title = "All Contacts"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Done,
            target: self,
            action: #selector(doneButtonTapped)
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
        tableView.allowsMultipleSelection = true
        
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
    
    private dynamic func doneButtonTapped() {
        let contacts = (self.tableView.indexPathsForSelectedRows ?? [])
            .map { indexPath in
                cache[indexPath.row]
            }
            .map(ContactReader.contactWithPhoneNumbersAndEmailAddresses)
        
        // TODO: Where to handle lack of phone number or email address?
        
        delegate?.contactPicker(self, didSelectContacts: contacts)
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
}

// MARK: - UISearchResultsUpdating

extension ContactMultiPickerViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let query = searchController.searchBar.text where !query.isEmpty else { return }
        
        searchResultsController.contacts = cache.search(query)
    }
}

// MARK: - FriendsListSearchResultsViewControllerDelegate

extension ContactMultiPickerViewController: ContactPickerSearchResultsViewControllerDelegate {
    func contactPicker(picker: ContactPickerSearchResultsViewController, didSelectContact contact: CNContact) {
        guard let row = cache.indexOf(contact) else { return }
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0), animated: true, scrollPosition: .None)
        
        searchController.active = false
    }
}
