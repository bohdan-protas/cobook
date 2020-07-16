//
//  CompanyPreviewHeaderTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CompanyPreviewHeaderTableViewCell: UITableViewCell {

    @IBOutlet var topCorneredView: UIView!
    @IBOutlet var avatarImageView: DesignableImageView!
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        topCorneredView.clipsToBounds = true
        topCorneredView.layer.cornerRadius = 10
        topCorneredView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
}
