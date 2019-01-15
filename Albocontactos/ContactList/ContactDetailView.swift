//
//  ContactDetailView.swift
//  Albocontactos
//
//  Created by Glauco Valdes on 1/14/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

import UIKit
import Contacts
import MessageUI
class ContactDetailView: UIViewController {

    @IBOutlet weak var capsLabel: UILabel!
    @IBOutlet weak var contactPicture: UIImageView!
    @IBOutlet weak var phoneButton: UIButton!
    var contact : CNContact = CNContact()
    var phoneNumber : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Init the style of the subviews
        
        contactPicture?.layer.cornerRadius = (contactPicture?.frame.size.width ?? 0.0) / 2
        contactPicture?.clipsToBounds = true
        contactPicture?.layer.borderWidth = 1.0
        contactPicture?.layer.borderColor = UIColor.gray.cgColor
        contactPicture?.contentMode = .scaleAspectFill
        
        capsLabel?.layer.cornerRadius = (contactPicture?.frame.size.width ?? 0.0) / 2
        capsLabel?.clipsToBounds = true
        capsLabel?.layer.borderWidth = 1.0
        capsLabel?.layer.borderColor = UIColor.gray.cgColor
        capsLabel.backgroundColor = UIColor(red: 235/255, green: 247/255, blue: 255/255, alpha: 1.0)
        capsLabel.textColor = UIColor.darkGray
        
        
        //Set the contact values
        self.title = contact.givenName
        capsLabel.text = String(contact.givenName.uppercased().first!) +  String(contact.familyName.uppercased().first!)
        contactPicture.image = nil
        if contact.imageDataAvailable{
            contactPicture.image = UIImage(data: contact.thumbnailImageData!)
        }
        phoneNumber = (contact.phoneNumbers.filter({$0.label == CNLabelPhoneNumberMobile}).last?.value.stringValue)!
        self.phoneButton.setTitle(phoneNumber, for: .normal)
    }
    @IBAction func phoneClicked(_ sender: Any) {
        //Handle the phone clicked
        
        let alertController = UIAlertController(title: "Contacto", message: "Selecciona una opción", preferredStyle: .actionSheet)
        let actionAdd = UIAlertAction(title: "Marcar", style: .default) { (action) in
            
                
            if let url = URL(string: "tel://" + self.phoneNumber.digits),
                    UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler:nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                
                
                
            
        }
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            
        }
        let actionMessage = UIAlertAction(title: "Enviar mensaje", style: .default) { (action) in
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.body = "Usa el app de contactos albo"
                controller.recipients = [(self.contact.phoneNumbers.filter({$0.label == CNLabelPhoneNumberMobile}).last?.value.stringValue)!]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
            
        }
        if(contact.phoneNumbers.filter({$0.label == CNLabelPhoneNumberMobile}).count > 0){
            alertController.addAction(actionAdd)
        }
        alertController.addAction(actionCancel)
        alertController.addAction(actionMessage)
        self.present(alertController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContactDetailView : MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
