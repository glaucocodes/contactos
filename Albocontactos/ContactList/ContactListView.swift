//
//  ContactListView.swift
//  Albocontactos
//
//  Created by Glauco Valdes on 1/8/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//


import UIKit
import Contacts
import MessageUI
class ContactListView: UIViewController,ContactListViewProtocol {
    
    @IBOutlet var contactTableView: UITableView!
    @IBOutlet weak var searchView: UISearchBar!
    
    var presenter:ContactListPresenterProtocol?
    var ContactList = [CNContact]()
    var AppContactList = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //List configuration using VIPER
        ContactListWireframe.createContactListModule(ContactListRef: self)
        presenter?.viewDidLoad()
        self.contactTableView.delegate = self
        self.contactTableView.dataSource = self
        self.searchView.delegate = self
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .denied:
            showSettingsAlert()
        case .restricted, .notDetermined:
            
            let store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler: { accessValue, error in
                if !accessValue{
                    self.showSettingsAlert()
                }
            })
            
        default:
            break
        }
    }
    
    func showSettingsAlert(){
        let alert = UIAlertController(title: nil, message: "La App usa tus contactos para encontrar usuarios que ya conoces. Así será más fácil y rápido interactuar con ellos", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ir a configuración", style: .default) { action in
            
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { action in
            
        })
        self.present(alert, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showContacts(with contacts: [CNContact]) {
        //Recive instruction to load or update the contact list view
        ContactList = Common.filterContacts(origin: contacts)
        AppContactList = Common.filterAppContacts(origin: contacts)
        contactTableView.reloadData()
    }
    
}

extension ContactListView: UITableViewDataSource, UITableViewDelegate {
    
    //Configuration of the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            //IF contact is already added to the app
            let cell : ContactsAppCell = contactTableView.dequeueReusableCell(withIdentifier: "contactAppCell", for: indexPath) as! ContactsAppCell
            let contact = AppContactList[indexPath.row]
            
            //Set the full name contact
            cell.nameLabel.text = contact.givenName + " " + contact.familyName
            //Set giveName and familyName first laters view
            cell.capsLabel.text = String(contact.givenName.uppercased().first!) +  String(contact.familyName.uppercased().first!)
            //Set the mobilephone
            cell.phoneLabel.text = (contact.phoneNumbers.filter({$0.label == CNLabelPhoneNumberMobile}).last?.value.stringValue)!
            //For recycling cell we remove previous image
            cell.contactPicture.image = nil
            
            //If contact has image show it
            if contact.imageDataAvailable{
                cell.contactPicture.image = UIImage(data: contact.thumbnailImageData!)
            }
            return cell
        case 1:
            //IF is regular contact
            let cell : ContactCell = contactTableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
            
            let contact = ContactList[indexPath.row]
            //Set the full name contact
            cell.nameLabel.text = contact.givenName + " " + contact.familyName
            //Set giveName and familyName first laters view
            cell.capsLabel.text = String(contact.givenName.uppercased().first!) +  String(contact.familyName.uppercased().first!)
            //For recycling cell we remove previous image
           cell.contactPicture.image = nil
            
            //If contact has image show it
            if contact.imageDataAvailable{
                cell.contactPicture.image = UIImage(data: contact.thumbnailImageData!)
            }
            return cell
        default:
            //Default condition
             let cell : ContactCell = contactTableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
             return cell
            
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            //Number of app contact list
            return AppContactList.count
        case 1:
            //Number of regular contacts
            return ContactList.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            //Show app contact detail view
            presenter?.showAppContactSelection(with: AppContactList[indexPath.row], from: self)
        case 1:
            //Show contact actions
            presenter?.showContactSelection(with: ContactList[indexPath.row], from: self)
        default:
            break
        }
        
    }
    
}

extension ContactListView : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Filter contacts
        presenter?.interactor?.getContactList(search: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Clear search
        searchBar.resignFirstResponder()
    }
}

extension ContactListView : MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //Handle messagess
    }
    
    
}


