//
//  ContactCache.swift
//  ContactPerformance
//
//  Created by Bryan Irace on 8/31/16.
//  Copyright © 2016 Bryan Irace. All rights reserved.
//

import Contacts

/**
 Differences from `CNContactPickerViewController:`
 
 - Is not sectioned (and as such, does not provide section index titles): http://nshipster.com/uilocalizedindexedcollation/
 */
final class ContactCache {
    private var contacts: [CNContact] = [] {
        didSet {
            searchIndex = contacts.map({ (contact) -> String in
                CNContactFormatter.stringFromContact(contact, style: .FullName)!.lowercaseString
            })
        }
    }

    private var searchIndex: [String] = []
    
    var count: Int {
        return contacts.count
    }
    
    func indexOf(contact: CNContact) -> Int? {
        return contacts.indexOf(contact)
    }
    
    subscript(index: Int) -> CNContact {
        return contacts[index]
    }
    
    func update(contacts: [CNContact]) {
        self.contacts = contacts
    }
    
    func search(query: String) -> [CNContact] {
        let lowercaseQuery = query.lowercaseString
        
        var matches: [CNContact] = []
        
        for (index, fullName) in searchIndex.enumerate() {
            if fullName.containsString(lowercaseQuery) {
                matches.append(contacts[index])
            }
        }
        
        return matches
    }
}
