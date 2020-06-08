//
//  FilterItemTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class FilterItemTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!

    override var isSelected: Bool {
        didSet {
            accessoryType = isSelected ? .checkmark : .none
        }
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        accessoryType = isSelected ? .checkmark : .none
//    }

}
