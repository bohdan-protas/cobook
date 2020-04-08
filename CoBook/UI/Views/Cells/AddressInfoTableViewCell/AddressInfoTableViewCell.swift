//
//  AddressInfoTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class AddressInfoTableViewCell: UITableViewCell {

    @IBOutlet var mainAddressLabel: UILabel!
    @IBOutlet var subadressLabel: UILabel!
    @IBOutlet var scheduleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        mainAddressLabel.text = ""
        subadressLabel.text = ""
        scheduleLabel.text = ""
    }

    
}
