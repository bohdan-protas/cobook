//
//  SearchResultHeaderView.swift
//  CoBook
//
//  Created by protas on 4/12/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SearchResultHeaderView: BaseFromNibView {

    @IBOutlet var resultsLabel: UILabel!

    override func getNib() -> UINib {
        return SearchResultHeaderView.nib
    }

    
}
