//
//  ContactsTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/15/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet var telephoneNumberLabel: UILabel!
    @IBOutlet var websiteLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        telephoneNumberLabel.text = ""
        websiteLabel.text = ""
        emailLabel.text = ""
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        telephoneNumberLabel.text = ""
        websiteLabel.text = ""
        emailLabel.text = ""
    }

}
