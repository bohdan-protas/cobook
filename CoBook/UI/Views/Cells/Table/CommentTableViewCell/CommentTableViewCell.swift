//
//  CommentTableViewCell.swift
//  CoBook
//
//  Created by Bogdan Protas on 19.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: DesignableImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
    }

    
}
