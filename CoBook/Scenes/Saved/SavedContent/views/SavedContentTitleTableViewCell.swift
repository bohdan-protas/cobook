//
//  SavedContentTitleTableViewCell.swift
//  CoBook
//
//  Created by protas on 5/15/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SavedContentTitleTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var actionButton: UIButton!

    var actionHandler: (() -> Void)?

    // MARK: Actions

    @IBAction func actionButtonTapped(_ sender: Any) {
        actionHandler?()
    }



}
