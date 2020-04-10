//
//  PersonalCardItemTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CardItemTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: DesignableTextPlaceholderImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var professionLabel: UILabel!
    @IBOutlet var telNumberLabel: UILabel!
    @IBOutlet var cardTypeContainerView: UIView!
    @IBOutlet var cardTypeImageView: UIImageView!
    @IBOutlet var cardTypeLabel: UILabel!

    var type: CardType? {
        didSet {
            switch type {
            case .none:
                cardTypeContainerView.backgroundColor = .white
                cardTypeImageView.image = nil
                cardTypeLabel.text = ""
            case .some(let value):
                switch value {
                case .personal:
                    cardTypeContainerView.backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.7333333333, blue: 0.368627451, alpha: 0.1026059503)
                    cardTypeImageView.image = #imageLiteral(resourceName: "ic_account_createparsonalcard")
                    cardTypeLabel.text = "Персональна візитка"
                    cardTypeLabel.textColor = UIColor.Theme.blackMiddle
                case .business:
                    cardTypeContainerView.backgroundColor = #colorLiteral(red: 1, green: 0.8549019608, blue: 0.1019607843, alpha: 0.1026059503)
                    cardTypeImageView.image = #imageLiteral(resourceName: "ic_account_createbusinescard")
                    cardTypeLabel.text = "Бізнес візитка"
                    cardTypeLabel.textColor = UIColor.Theme.greenDark
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = ""
        professionLabel.text = ""
        telNumberLabel.text = ""
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.cancelImageRequest()
        avatarImageView.image = nil
        nameLabel.text = ""
        professionLabel.text = ""
        telNumberLabel.text = ""
    }

    
}
