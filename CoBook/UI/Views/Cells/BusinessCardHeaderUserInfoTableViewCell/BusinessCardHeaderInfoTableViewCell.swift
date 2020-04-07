//
//  BusinessCardHeaderInfoTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class BusinessCardHeaderInfoTableViewCell: UITableViewCell {

    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var avatarImageView: DesignableImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var professionLabel: UILabel!
    @IBOutlet var telephoneNumberLabel: UILabel!
    @IBOutlet var websiteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        professionLabel.text = ""
        telephoneNumberLabel.text = ""
        websiteLabel.text = ""
        bgImageView.image = nil
        avatarImageView.image = nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.text = ""
        professionLabel.text = ""
        telephoneNumberLabel.text = ""
        websiteLabel.text = ""
        bgImageView.cancelImageRequest()
        avatarImageView.cancelImageRequest()
        bgImageView.image = nil
        avatarImageView.image = nil
    }
    
}
