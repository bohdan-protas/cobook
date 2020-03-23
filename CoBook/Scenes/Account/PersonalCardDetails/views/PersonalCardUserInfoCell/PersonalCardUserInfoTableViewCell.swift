//
//  PersonalCardUserInfoTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class PersonalCardUserInfoTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var practiceTypeLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var telephoneNumberLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        userNameLabel.text = ""
        practiceTypeLabel.text = ""
        positionLabel.text = ""
        telephoneNumberLabel.text = ""
        descriptionLabel.text = ""
        locationLabel.text = ""
    }

    
}
