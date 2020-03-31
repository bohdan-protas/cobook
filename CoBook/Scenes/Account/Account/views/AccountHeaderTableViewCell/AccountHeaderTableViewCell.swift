//
//  AccountHeaderTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class AccountHeaderTableViewCell: UITableViewCell {

    @IBOutlet var avatarTextPlaceholderImageView: DesignableTextPlaceholderImageView!
    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var telephoneNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var settingsButton: DesignableButton!

    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = ""
        telephoneNumberLabel.text = ""
        emailLabel.text = ""
        avatarTextPlaceholderImageView.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        userNameLabel.text = ""
        telephoneNumberLabel.text = ""
        emailLabel.text = ""
        avatarTextPlaceholderImageView.image = nil
    }

    
}
