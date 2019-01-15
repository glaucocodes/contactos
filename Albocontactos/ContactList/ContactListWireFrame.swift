//
//  ContactListWireFrame.swift
//  Albocontactos
//
//  Created by Glauco Valdes on 1/8/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

import UIKit
import Contacts

class ContactListWireframe: ContactListWireFrameProtocol {
    
    class func createContactListModule(ContactListRef: ContactListView) {
        let presenter: ContactListPresenterProtocol & ContactListOutputInteractorProtocol = ContactListPresenter()
        
        ContactListRef.presenter = presenter
        ContactListRef.presenter?.wireframe = ContactListWireframe()
        ContactListRef.presenter?.view = ContactListRef
        ContactListRef.presenter?.interactor = ContactListInteractor()
        ContactListRef.presenter?.interactor?.presenter = presenter
    }
    
}
