//
//  PersonalCardItemTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class PersonalCardItemTableViewCell: UITableViewCell {

    @IBOutlet var userAvatarImageView: DesignableImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var professionLabel: UILabel!
    @IBOutlet var telNumberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userAvatarImageView.cancelImageRequest()
        nameLabel.text = ""
        professionLabel.text = ""
        telNumberLabel.text = ""
    }

    
}
