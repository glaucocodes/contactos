//
//  ContactCell.swift
//  Albocontactos
//
//  Created by Glauco Valdes on 1/14/19.
//  Copyright © 2019 Glauco Valdes. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var contactPicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
