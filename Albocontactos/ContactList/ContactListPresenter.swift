//
//  ContactListPresenter.swift
//  Albocontactos
//
//  Created by Glauco Valdes on 1/8/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

import UIKit
import Contacts
import MessageUI

class ContactListPresenter: ContactListPresenterProtocol {
    
    var wireframe: ContactListWireFrameProtocol?
    var view: ContactListViewProtocol?
    var interactor: ContactListInputInteractorProtocol?
    var presenter: ContactListPresenterProtocol?
    
    func showContactSelection(with contact: CNContact, from view: UIViewController) {
        
        //Manage to invite a contact to use the app or add to already app contacts
        let alertController = UIAlertController(title: "Contacto", message: "Selecciona una opción", preferredStyle: .actionSheet)
        let actionAdd = UIAlertAction(title: "Agregar al app", style: .default) { (action) in
            if(contact.phoneNumbers.filter({$0.label == CNLabelPhoneNumberMobile}).count > 0){
                Common.saveAppContact(phoneNumber: (contact.phoneNumbers.filter({$0.label == CNLabelPhoneNumberMobile}).last?.value.stringValue)!)
            
               
                self.ContactListDidFetch(ContactList: Common.generateDataList(searchValue: (view as? ContactListView)?.searchView.text ?? ""))
            
            }
        }
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            
        }
        let actionMessage = UIAlertAction(title: "Enviar mensaje", style: .default) { (action) in
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "Usa el app de contactos albo"
                controller.recipients = [(contact.phoneNumbers.filter({$0.label == CNLabelPhoneNumberMobile}).last?.value.stringValue)!]
                controller.messageComposeDelegate = view as? ContactListView
                view.present(controller, animated: true, completion: nil)
            }
            
        }
         if(contact.phoneNumbers.filter({$0.label == CNLabelPhoneNumberMobile}).count > 0){
            alertController.addAction(actionAdd)
        }
        alertController.addAction(actionCancel)
        alertController.addAction(actionMessage)
        view.present(alertController, animated: true, completion: nil)
        
    }
    func showAppContactSelection(with contact: CNContact, from view: UIViewController) {
        //Show app contact detail
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC : ContactDetailView = mainStoryboard.instantiateViewController(withIdentifier: "DetailView") as! ContactDetailView
        detailVC.contact = contact
        view.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    func viewDidLoad() {
        self.loadContactList()
    }
    
    func loadContactList() {
        interactor?.getContactList()
    }
    
    func loadContactList(search : String) {
        interactor?.getContactList(search: search)
    }
    
}

extension ContactListPresenter: ContactListOutputInteractorProtocol {
    
    func ContactListDidFetch(ContactList: [CNContact]) {
        view?.showContacts(with: ContactList)
    }
    
}
