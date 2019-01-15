//
//  ContactListProtocols.swift
//  Albocontactos
//
//  Created by Glauco Valdes on 1/8/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

import Foundation
import UIKit
import Contacts

protocol ContactListViewProtocol: class {
    // PRESENTER -> VIEW
    func showContacts(with contacts: [CNContact])
}

protocol ContactListPresenterProtocol: class {
    //View -> Presenter
    var interactor: ContactListInputInteractorProtocol? {get set}
    var view: ContactListViewProtocol? {get set}
    var wireframe: ContactListWireFrameProtocol? {get set}
    
    func viewDidLoad()
    func showContactSelection(with contact: CNContact, from view: UIViewController)
    func showAppContactSelection(with contact: CNContact, from view: UIViewController)
}

protocol ContactListInputInteractorProtocol: class {
    var presenter: ContactListOutputInteractorProtocol? {get set}
    //Presenter -> Interactor
    func getContactList()
    func getContactList(search:String)
}

protocol ContactListOutputInteractorProtocol: class {
    //Interactor -> Presenter
    func ContactListDidFetch(ContactList: [CNContact])
}

protocol ContactListWireFrameProtocol: class {
    //Presenter -> Wireframe
    static func createContactListModule(ContactListRef: ContactListView)
}
