//
//  AccountBusinessCardTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class AccountBusinessCardTableViewCell: UITableViewCell {

    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var proffesionLabel: UILabel!
    @IBOutlet var telephoneNumberLabel: UILabel!

    override func prepareForReuse() {
        titleImageView.image = nil
        companyNameLabel.text = ""
        proffesionLabel.text = ""
        telephoneNumberLabel.text = ""
    }

    func fill(with model: Account.BusinessCard) {

    }
    
}
