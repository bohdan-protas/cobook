//
//  SocialListItemCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 3/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SocialListItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var socialImageView: UIImageView!
    @IBOutlet var socialTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        socialImageView.backgroundColor = UIColor.Theme.grayBG
        socialImageView.layer.cornerRadius = socialImageView.frame.height / 2
        socialImageView.layer.masksToBounds = true
    }

}
