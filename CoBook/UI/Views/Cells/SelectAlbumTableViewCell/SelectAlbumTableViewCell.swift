//
//  SelectAlbumTableViewCell.swift
//  CoBook
//
//  Created by protas on 5/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SelectAlbumTableViewCell: UITableViewCell {

    @IBOutlet var albumImageView: DesignableImageView!
    @IBOutlet var albumTitleLabel: UILabel!

    @IBAction func editButtonTapped(_ sender: Any) {

    }

    override var isSelected: Bool {
        didSet {
            albumImageView.borderWidth = isSelected ? 3 : 0
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.cancelImageRequest()
        albumImageView.image = nil
    }

}
