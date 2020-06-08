//
//  AccountHeaderTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol AccountHeaderTableViewCellDelegate: class {
    func settingTapped(cell: AccountHeaderTableViewCell)
    func userPhotoTapped(cell: AccountHeaderTableViewCell)
}

class AccountHeaderTableViewCell: UITableViewCell {

    @IBOutlet var avatarTextPlaceholderImageView: DesignableImageView!
    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var telephoneNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var settingsButton: DesignableButton!

    weak var delegate: AccountHeaderTableViewCellDelegate?

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        userNameLabel.text = ""
        telephoneNumberLabel.text = ""
        emailLabel.text = ""
        avatarTextPlaceholderImageView.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        userNameLabel.text = ""
        telephoneNumberLabel.text = ""
        emailLabel.text = ""
        avatarTextPlaceholderImageView.image = nil

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(userPhotoTapped))
        avatarTextPlaceholderImageView.addGestureRecognizer(tapRecognizer)
    }

    // MARK: - Actions

    @IBAction func settingsButtonTapped(_ sender: Any) {
        delegate?.settingTapped(cell: self)
    }

    @IBAction func userPhotoTapped(_ sender: Any) {
        delegate?.userPhotoTapped(cell: self)
    }


    
}
