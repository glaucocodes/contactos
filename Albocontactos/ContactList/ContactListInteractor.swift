//
//  ContactListInteractor.swift
//  Albocontactos
//
//  Created by Glauco Valdes on 1/8/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

import UIKit
import Contacts

class ContactListInteractor: ContactListInputInteractorProtocol {
               
    weak var presenter: ContactListOutputInteractorProtocol?
    
    func getContactList() {
        //Get contact list without searchtext
        presenter?.ContactListDidFetch(ContactList: getAllContactDetail())
    }
    func getContactList(search: String) {
        //Get contact list with filter search
        presenter?.ContactListDidFetch(ContactList: getAllContactDetail(search: search))
    }
    
    func getAllContactDetail() -> [CNContact] {
        //Get all contacts
        var ContactList = [CNContact]()
        let allContactDetail = Common.generateDataList()
        for item in allContactDetail {
            ContactList.append(item)
        }
        return ContactList
    }
    
    func getAllContactDetail(search : String) -> [CNContact] {
        //Get all contacts search
        var ContactList = [CNContact]()
        let allContactDetail = Common.generateDataList(searchValue: search)
        for item in allContactDetail {
            ContactList.append(item)
        }
        return ContactList
    }
}
