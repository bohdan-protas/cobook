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
    @IBOutlet var detailInfoTextView: DesignableTextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        clearLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearLayout()
    }

    private func clearLayout() {
        avatarImageView.cancelImageRequest()
        userNameLabel.text = ""
        practiceTypeLabel.text = ""
        positionLabel.text = ""
        telephoneNumberLabel.text = ""
    }

    
}
