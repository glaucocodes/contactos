//
//  Common.swift
//  Albocontactos
//
//  Created by Glauco Valdes on 1/8/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

import UIKit
import Contacts
import CoreData
import Foundation
class Common: NSObject {
    
    class func generateDataList(searchValue : String) -> [CNContact] {
        //Get contactas from sdk and filter by name and phone number
        //Onlye showing contacts with MobilePhoneNumber
        var contacts = [CNContact]()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactEmailAddressesKey,
                    CNContactPhoneNumbersKey,
                    CNContactImageDataAvailableKey,
                    CNContactImageDataKey,
                    CNContactThumbnailImageDataKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        
        do {
            let store = CNContactStore()
            try store.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        
        if(searchValue == ""){
            return contacts.filter({
                $0.phoneNumbers.contains(where: {$0.label == CNLabelPhoneNumberMobile})
            }).sorted{$0.givenName < $1.givenName}
        }else{
            return contacts.filter({($0.givenName.lowercased().contains(searchValue.lowercased())
                || $0.familyName.lowercased().contains(searchValue.lowercased())
                || $0.phoneNumbers.contains(where: {$0.value.stringValue.contains(searchValue) })
                )
                &&
                $0.phoneNumbers.contains(where: {$0.label == CNLabelPhoneNumberMobile})
                }
            ).sorted{$0.givenName < $1.givenName}
        }
    }
    
    class func generateDataList() -> [CNContact] {
        //Get contactas from sdk
        //Onlye showing contacts with MobilePhoneNumber
        var contacts = [CNContact]()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                    CNContactEmailAddressesKey,
                    CNContactPhoneNumbersKey,
                    CNContactImageDataKey,
                    CNContactImageDataAvailableKey,
                    CNContactThumbnailImageDataKey] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        
        do {
            let store = CNContactStore()
            try store.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        
            return contacts.filter({
                $0.phoneNumbers.contains(where: {$0.label == CNLabelPhoneNumberMobile})
            }).sorted{$0.givenName < $1.givenName}
    }
    
    class func saveContactArray(contact:CNContact){
        //First exersice aproach using userdefaults to store contacts
        var localArray = getContactArray()
        localArray.append(contact)
        let defaults = UserDefaults.standard
        defaults.set(localArray, forKey: "usedContacts")
    }
    
    class func getContactArray() -> [CNContact]{
        //First exersice aproach using userdefaults to store contacts
        let defaults = UserDefaults.standard
        let array = defaults.array(forKey: "usedContacts")  as? [CNContact] ?? [CNContact]()
        return array
    }
    
    class func saveAppContact(phoneNumber:String){
        //Save on core data mobile cotact number to app
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let appContactEntity = NSEntityDescription.entity(forEntityName: "AppContact", in: managedContext)!
        let appContact = NSManagedObject(entity: appContactEntity, insertInto: managedContext)
        appContact.setValue(phoneNumber,forKey: "phone_number")
        
        do {
            try managedContext.save()
        } catch _ as NSError {
        }
    }
    
    class func getAppContactList()->[AppContact]{
        //Get list of app contacts mobile numbers using coredata
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [AppContact]() }
        let managedContext = appDelegate.persistentContainer.viewContext
        let appContactFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AppContact")
        let appContactResults = try! managedContext.fetch(appContactFetch)
        
        return appContactResults as! [AppContact]
    }
    
    class func filterAppContacts(origin: [CNContact])->[CNContact]{
        //Get appcontacts
        var contactsFiltered = [CNContact]()
        for tempContact in getAppContactList(){
            contactsFiltered.append(contentsOf: origin.filter({$0.phoneNumbers.contains(where: {$0.label == CNLabelPhoneNumberMobile && $0.value.stringValue == tempContact.phone_number})}))
        }
        return contactsFiltered.sorted{$0.givenName < $1.givenName}
    }
    
    class func filterContacts(origin: [CNContact])->[CNContact]{
        //Get regular contacts
        var contactsFiltered = [CNContact]()
        contactsFiltered = Array(Set(origin).subtracting(filterAppContacts(origin: origin)))
        return contactsFiltered.sorted{$0.givenName < $1.givenName}
    }
    
    
}

extension String {
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}


