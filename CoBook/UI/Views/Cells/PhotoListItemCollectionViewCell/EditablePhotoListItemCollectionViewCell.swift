//
//  EditablePhotoListItemCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 4/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class EditablePhotoListItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var addPhotoPlaceholderView: DesignableView!


    // MARK: - View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleImageView.cancelImageRequest()
    }

}
