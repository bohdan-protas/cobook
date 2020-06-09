//
//  ActionTitleTableViewCell.swift
//  CoBook
//
//  Created by protas on 5/28/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class ActionTitleTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var actionButton: UIButton!

    var actionHandler: (() -> Void)?

    @IBAction func actionButtonTapped(_ sender: Any) {
        actionHandler?()
    }

    
}
