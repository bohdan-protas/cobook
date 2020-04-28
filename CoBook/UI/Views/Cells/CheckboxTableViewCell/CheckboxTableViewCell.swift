//
//  CheckboxTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CheckboxTableViewCell: UITableViewCell {

    @IBOutlet var checkboxButton: UIButton!

    var checkboxActionHandler: ((_ button: UIButton) -> Void)?

    @IBAction func checkboxButtonTapped(_ sender: UIButton) {
        checkboxActionHandler?(sender)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        checkboxActionHandler = nil
    }

    
}
