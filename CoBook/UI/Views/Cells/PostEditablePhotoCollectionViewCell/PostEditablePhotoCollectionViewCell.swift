//
//  PostEditablePhotoCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 5/3/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol PostEditablePhotoCollectionViewCellDelegate: class {
    func delete(_ cell: PostEditablePhotoCollectionViewCell)
}

class PostEditablePhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var deleteButton: DesignableButton!

    weak var delegate: PostEditablePhotoCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 10
        photoImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.delete(self)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.cancelImageRequest()
        photoImageView.image = nil
    }


}
