//
//  ActionTitleCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 6/9/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class ActionTitleCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var actionButton: UIButton!

    @IBOutlet var widthConstraint: NSLayoutConstraint!

    var actionHandler: (() -> Void)?

    @IBAction func actionButtonTapped(_ sender: Any) {
        actionHandler?()
    }

}
