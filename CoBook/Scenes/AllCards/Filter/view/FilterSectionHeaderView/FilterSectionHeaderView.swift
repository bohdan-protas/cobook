//
//  FilterSectionHeaderView.swift
//  CoBook
//
//  Created by protas on 4/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class FilterSectionHeaderView: BaseFromNibView {

    @IBOutlet var titleLabel: UILabel!

    override func getNib() -> UINib {
        return FilterSectionHeaderView.nib
    }

}
