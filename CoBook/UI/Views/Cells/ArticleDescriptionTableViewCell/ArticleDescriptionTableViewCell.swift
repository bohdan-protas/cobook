//
//  ArticleDescriptionTableViewCell.swift
//  CoBook
//
//  Created by protas on 5/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class ArticleDescriptionTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var albumImageView: DesignableImageView!
    @IBOutlet var albumNameLabel: UILabel!
    @IBOutlet var descriptionTextView: DesignableTextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
