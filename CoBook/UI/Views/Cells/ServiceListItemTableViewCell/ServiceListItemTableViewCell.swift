//
//  ServiceListItemTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class ServiceListItemTableViewCell: UITableViewCell {

    @IBOutlet var titleImageView: DesignableImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        titleLabel.text = ""
        subtitleLabel.text = ""
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleImageView.image = nil
        titleImageView.cancelImageRequest()
        titleLabel.text = ""
        subtitleLabel.text = ""
    }
    
}
