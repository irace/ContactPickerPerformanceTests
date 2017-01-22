//
//  ContactPerformanceTests.swift
//  ContactPerformanceTests
//
//  Created by Bryan Irace on 8/30/16.
//  Copyright © 2016 Bryan Irace. All rights reserved.
//

import XCTest
import Contacts

class ContactPerformanceTests: XCTestCase {
    let fullNameKeys: [CNKeyDescriptor] = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName)]
    let lotsOfKeys: [CNKeyDescriptor] = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
                                         CNContactTypeKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,
                                         CNContactEmailAddressesKey, CNContactSocialProfilesKey, CNContactOrganizationNameKey, CNContactNoteKey]
    let defaultDisplayKeys = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactImageDataKey]

    
    var store: CNContactStore!
    
    override func setUp() {
        super.setUp()

        store = CNContactStore()
    }
    
    // Consider trying `ABAddressBook` too: https://github.com/erica/ABContactHelper/blob/master/Address%20Book%20Wrappers/ABContactsHelper.m#L24
    
    func testEnumerateAllContactsFetchingFullNameKeys() {
        self.measureBlock {
            self.enumerateAllContacts(withRequest: CNContactFetchRequest(keysToFetch: self.fullNameKeys))
        }
    }
    
    func testEnumerateAllContactsFetchingFullNameKeysWithoutUnifiedResults() {
        let fetchRequest = CNContactFetchRequest(keysToFetch: self.fullNameKeys)
        fetchRequest.unifyResults = false
        
        self.measureBlock {
            self.enumerateAllContacts(withRequest: fetchRequest)
        }
    }
    
    func testEnumerateAllContactsFetchingFullNameKeysWithoutUnifiedResultsWithUserDefaultSortOrder() {
        let fetchRequest = CNContactFetchRequest(keysToFetch: self.fullNameKeys)
        fetchRequest.unifyResults = false
        fetchRequest.sortOrder = .UserDefault
        
        self.measureBlock {
            self.enumerateAllContacts(withRequest: fetchRequest)
        }
    }
    
    func testEnumerateAllContactsFetchingFullNameKeysWithoutUnifiedResultsInDefaultContainer() {
        let fetchRequest = CNContactFetchRequest(keysToFetch: self.fullNameKeys)
        fetchRequest.unifyResults = false
        fetchRequest.predicate = CNContact.predicateForContactsInContainerWithIdentifier(store.defaultContainerIdentifier())
        
        self.measureBlock {
            self.enumerateAllContacts(withRequest: fetchRequest)
        }
    }

    func testEnumerateAllContactsFetchingDefaultDisplayKeys() {
        self.measureBlock {
            self.enumerateAllContacts(withRequest: CNContactFetchRequest(keysToFetch: self.defaultDisplayKeys))
        }
    }

    func testEnumerateAllContactsFetchingDefaultDisplayKeysWithoutUnifiedResults() {
        let fetchRequest = CNContactFetchRequest(keysToFetch: self.defaultDisplayKeys)
        fetchRequest.unifyResults = false
        
        self.measureBlock {
            self.enumerateAllContacts(withRequest: fetchRequest)
        }
    }
    
    func testEnumerateAllContactsFetchingDefaultDisplayKeysWithoutUnifiedResultsInDefaultContainer() {
        let fetchRequest = CNContactFetchRequest(keysToFetch: self.defaultDisplayKeys)
        fetchRequest.unifyResults = false
        fetchRequest.predicate = CNContact.predicateForContactsInContainerWithIdentifier(store.defaultContainerIdentifier())
        
        self.measureBlock {
            self.enumerateAllContacts(withRequest: fetchRequest)
        }
    }
    
    func testEnumerateAllContactsFetchingLotsOfKeys() {
        self.measureBlock {
            self.enumerateAllContacts(withRequest: CNContactFetchRequest(keysToFetch: self.lotsOfKeys))
        }
    }
    
    func testEnumerateAllContactsFetchingLotsOfKeysWithoutUnifiedResults() {
        let fetchRequest = CNContactFetchRequest(keysToFetch: self.lotsOfKeys)
        fetchRequest.unifyResults = false
        
        self.measureBlock {
            self.enumerateAllContacts(withRequest: fetchRequest)
        }
    }
    
    func testEnumerateAllContactsFetchingLotsOfKeysWithoutUnifiedResultsInDefaultContainer() {
        let fetchRequest = CNContactFetchRequest(keysToFetch: self.lotsOfKeys)
        fetchRequest.unifyResults = false
        fetchRequest.predicate = CNContact.predicateForContactsInContainerWithIdentifier(store.defaultContainerIdentifier())
        
        self.measureBlock {
            self.enumerateAllContacts(withRequest: fetchRequest)
        }
    }
    
    func testUnifiedContactsInDefaultContainerFetchingFullNameKeys() {
        self.measureBlock {
            self.unifiedContacts(keysToFetch: self.fullNameKeys)
        }
    }
    
    func testUnifiedContactsInDefaultContainerFetchingLotsOfKeys() {
        self.measureBlock {
            self.unifiedContacts(keysToFetch: self.lotsOfKeys)
        }
    }
    
    // MARK: - Helpers

    func unifiedContacts(keysToFetch keysToFetch: [CNKeyDescriptor]) {
        try! store.unifiedContactsMatchingPredicate(
            CNContact.predicateForContactsInContainerWithIdentifier(store.defaultContainerIdentifier()),
            keysToFetch: keysToFetch
        )
    }
    
    func enumerateAllContacts(withRequest fetchRequest: CNContactFetchRequest) {
        try! self.store.enumerateContactsWithFetchRequest(fetchRequest) { (_, _) in }
    }
}
