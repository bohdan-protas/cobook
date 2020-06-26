//
//  AccountBusinessCardTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CardPreviewTableViewCell: UITableViewCell {

    @IBOutlet var titleImageView: DesignableImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var proffesionLabel: UILabel!
    @IBOutlet var telephoneNumberLabel: UILabel!
    @IBOutlet var separatorView: UIView!

    override func prepareForReuse() {
        titleImageView.cancelImageRequest()
        titleImageView.image = nil
        titleLabel.text = ""
        detailLabel.isHidden = true
        detailLabel.text = ""
        proffesionLabel.text = ""
        telephoneNumberLabel.text = ""
    }
    
}
