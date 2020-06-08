//
//  PhotoGalleryItemCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 6/2/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class PhotoGalleryItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelImageRequest()
        imageView.image = nil
    }

}
