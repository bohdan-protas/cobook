//
//  MapTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class MapTableViewCell: UITableViewCell {

    @IBOutlet var mapImageView: UIImageView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        mapImageView.image = nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mapImageView.cancelImageRequest()
    }


}
