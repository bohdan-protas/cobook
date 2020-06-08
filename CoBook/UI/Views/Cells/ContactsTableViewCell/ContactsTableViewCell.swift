//
//  ContactsTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/15/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @Localized("Label.contacts.text")
    @IBOutlet var headerLabel: UILabel!

    @IBOutlet var telephoneNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var websiteButton: UIButton!

    @IBAction func websiteButtonTapped(_ sender: Any) {
        if let url = URL.init(string: websiteButton.currentAttributedTitle?.string ?? "") {
            UIApplication.shared.open(url)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        telephoneNumberLabel.text = ""
        emailLabel.text = ""
    }

}

