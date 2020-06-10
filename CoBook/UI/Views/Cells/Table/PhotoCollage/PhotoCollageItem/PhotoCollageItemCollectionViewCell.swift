//
//  PhotoCollageItemCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 5/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class PhotoCollageItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var photoImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()

        photoImageView.cancelImageRequest()
        photoImageView.image = nil
    }

}
