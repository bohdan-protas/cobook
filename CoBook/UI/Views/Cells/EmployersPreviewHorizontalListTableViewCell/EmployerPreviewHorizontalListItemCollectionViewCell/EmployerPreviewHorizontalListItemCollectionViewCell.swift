//
//  EmployerPreviewHorizontalListItemCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 4/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol EmployerPreviewHorizontalListItemCollectionViewCellDelegate: class {
    func onDelete(_ cell: EmployerPreviewHorizontalListItemCollectionViewCell)
}

class EmployerPreviewHorizontalListItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var avatarTextPlaceholderImageView: DesignableImageView!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var professionLabel: UILabel!
    @IBOutlet var telNumberLabel: UILabel!

    weak var delegate: EmployerPreviewHorizontalListItemCollectionViewCellDelegate?

    // MARK: Actions
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        delegate?.onDelete(self)
    }

    // MARK: View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
        professionLabel.text = ""
        telNumberLabel.text = ""
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarTextPlaceholderImageView.af.cancelImageRequest()
        avatarTextPlaceholderImageView.image = nil
        titleLabel.text = ""
        professionLabel.text = ""
        telNumberLabel.text = ""
    }

}
