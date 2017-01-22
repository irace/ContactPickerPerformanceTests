//
//  ContactReader.swift
//  ContactPerformance
//
//  Created by Bryan Irace on 8/31/16.
//  Copyright © 2016 Bryan Irace. All rights reserved.
//

import Contacts

/**
 Differences from `CNContactPickerViewController:`
 
 - No way to (efficiently) filter out contacts without email addresses or phone numbers, so will have to handle this 
   after selection.
 */
final class ContactReader {
    private static let store = CNContactStore()
    
    static func all(completion: [CNContact] -> Void) {
        let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName)])
        fetchRequest.unifyResults = false
        fetchRequest.sortOrder = .UserDefault

        var contacts: [CNContact] = []
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        
        dispatch_async(queue) {
            try! store.enumerateContactsWithFetchRequest(fetchRequest) { (contact, _) in
                contacts.append(contact)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                completion(contacts)
            }
        }
    }
    
    static func contactWithPhoneNumbersAndEmailAddresses(fromContact contact: CNContact) -> CNContact {
        return try! store.unifiedContactWithIdentifier(
            contact.identifier,
            keysToFetch: [
                CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                CNContactPhoneNumbersKey,
                CNContactEmailAddressesKey
            ]
        )
    }
}
