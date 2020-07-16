//
//  ProductPreviewItemTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/29/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class ProductPreviewItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleImageView: DesignableImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        productNameLabel.text = ""
        productPriceLabel.text = ""
    }

    override func prepareForReuse() {
        productNameLabel.text = ""
        productPriceLabel.text = ""
    }

    
}
