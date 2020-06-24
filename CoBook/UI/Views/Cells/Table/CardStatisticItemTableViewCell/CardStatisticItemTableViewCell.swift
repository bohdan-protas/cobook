//
//  CardStatisticItemTableViewCell.swift
//  CoBook
//
//  Created by Bogdan Protas on 21.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CardStatisticItemTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: DesignableImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var professionLabel: UILabel!
    @IBOutlet var telephoneLabel: UILabel!
    
    @Localized("Statistic.viewsCount.title" )
    @IBOutlet var viewsCountTitleLabel: UILabel!
    @IBOutlet var viewsCountValueLabel: UILabel!
    
    @Localized("Statistic.savedCount.title")
    @IBOutlet var savedCountTitleLabel: UILabel!
    @IBOutlet var savedCountValueLabel: UILabel!
    
    @Localized("Statistic.shareCount.title")
    @IBOutlet var sharingCountTitleLabel: UILabel!
    @IBOutlet var sharingCountValueLabel: UILabel!
    

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        professionLabel.text = ""
        telephoneLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.cancelImageRequest()
        avatarImageView.image = nil
    }

    
}
