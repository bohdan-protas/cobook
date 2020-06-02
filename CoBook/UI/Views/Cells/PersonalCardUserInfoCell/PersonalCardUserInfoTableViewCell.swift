//
//  PersonalCardUserInfoTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol PersonalCardUserInfoTableViewCellDelegate: class {
    func onSaveCard(cell: PersonalCardUserInfoTableViewCell)
}

class PersonalCardUserInfoTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var practiceTypeLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var telephoneNumberLabel: UILabel!
    @IBOutlet var detailInfoTextView: DesignableTextView!
    @IBOutlet var saveButton: DesignableButton!
    @IBOutlet var userInfoContainer: UIView!

    weak var delegate: PersonalCardUserInfoTableViewCellDelegate?

    // MARK: - Actions

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        delegate?.onSaveCard(cell: self)
    }

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        clearLayout()

        userInfoContainer.clipsToBounds = true
        userInfoContainer.layer.cornerRadius = 10
        userInfoContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearLayout()
    }


}

// MARK: - PersonalCardUserInfoTableViewCell

private extension PersonalCardUserInfoTableViewCell {

    func clearLayout() {
        avatarImageView.cancelImageRequest()
        userNameLabel.text = ""
        practiceTypeLabel.text = ""
        positionLabel.text = ""
        telephoneNumberLabel.text = ""
    }


}
