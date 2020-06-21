//
//  CardStatisticItemTableViewCell.swift
//  CoBook
//
//  Created by Bogdan Protas on 21.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CardStatisticItemTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: DesignableImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var viewsCountTitleLabel: UILabel!
    @IBOutlet weak var viewsCountValueLabel: UILabel!
    @IBOutlet weak var savedCountTitleLabel: UILabel!
    @IBOutlet weak var savedCountValueLabel: UILabel!
    @IBOutlet weak var sharingCountTitleLabel: UILabel!
    @IBOutlet weak var sharingCountValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
