//
//  AlbumPreviewItemCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 4/30/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class AlbumPreviewItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleImageView: DesignableImageView!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var addItemIndicator: DesignableView!
    @IBOutlet var arrowIndicatorImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        titleImageView.cancelImageRequest()
        titleImageView.image = nil
        textLabel.text = ""
        arrowIndicatorImageView.isHidden = true
    }


}
