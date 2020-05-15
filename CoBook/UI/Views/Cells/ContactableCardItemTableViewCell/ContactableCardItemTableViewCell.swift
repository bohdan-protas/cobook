//
//  ContactableCardItemTableViewCell.swift
//  CoBook
//
//  Created by protas on 5/14/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol ContactableCardItemTableViewCellDelegate: class {

}

class ContactableCardItemTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: DesignableImageView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var telNumberLabel: UILabel!
    @IBOutlet var cardTypeContainerView: UIView!
    @IBOutlet var cardTypeImageView: UIImageView!
    @IBOutlet var cardTypeLabel: UILabel!
    @IBOutlet var saveButton: DesignableButton!

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

    weak var delegate: ContactableCardItemTableViewCellDelegate?

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.cancelImageRequest()
        avatarImageView.image = nil
        headerLabel.text = ""
        bodyLabel.text = ""
        telNumberLabel.text = ""
    }

    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: Any) {

    }

    @IBAction func callButtonTapped(_ sender: Any) {

    }

    @IBAction func sendEmailButtonTapped(_ sender: Any) {

    }

}

// MARK: - Privates

private extension ContactableCardItemTableViewCell {

}
