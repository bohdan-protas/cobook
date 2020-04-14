//
//  AccountBusinessCardTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CardPreviewTableViewCell: UITableViewCell {

    @IBOutlet var titleImageView: DesignableTextPlaceholderImageView!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var proffesionLabel: UILabel!
    @IBOutlet var telephoneNumberLabel: UILabel!

    override func prepareForReuse() {
        titleImageView.cancelImageRequest()
        titleImageView.image = nil
        companyNameLabel.text = ""
        proffesionLabel.text = ""
        telephoneNumberLabel.text = ""
    }
    
}
