//
//  SelectAlbumTableViewCell.swift
//  CoBook
//
//  Created by protas on 5/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol SelectAlbumTableViewCellDelegate: class {
    func editAction(_ cell: SelectAlbumTableViewCell)
}

class SelectAlbumTableViewCell: UITableViewCell {

    @IBOutlet var albumImageView: DesignableImageView!
    @IBOutlet var albumTitleLabel: UILabel!
    @IBOutlet var editButton: UIButton!

    weak var delegate: SelectAlbumTableViewCellDelegate?

    @IBAction func editButtonTapped(_ sender: Any) {
        delegate?.editAction(self)
    }

    override var isSelected: Bool {
        didSet {
            albumTitleLabel.textColor = isSelected ? UIColor.Theme.greenDark : UIColor.Theme.blackMiddle
            albumImageView.borderWidth = isSelected ? 3 : 0
        }
    }


}
