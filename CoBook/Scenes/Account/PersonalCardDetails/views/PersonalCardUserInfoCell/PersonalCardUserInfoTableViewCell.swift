//
//  PersonalCardUserInfoTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import Kingfisher

class PersonalCardUserInfoTableViewCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var practiceTypeLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var telephoneNumberLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        clearLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearLayout()

    }

    private func clearLayout() {
        avatarImageView.kf.cancelDownloadTask()
        userNameLabel.text = ""
        practiceTypeLabel.text = ""
        positionLabel.text = ""
        telephoneNumberLabel.text = ""
        descriptionLabel.text = ""
        locationLabel.text = ""

    }

    func fill(with model: CardAPIModel.CardDetailsAPIResponseData?) {
        self.avatarImageView.kf.setImage(with: URL.init(string: model?.avatar?.sourceUrl ?? ""),
                                         placeholder: UIImage(named: "ic_user"),
                                         options: [.transition(.fade(0.3))]
        )
        self.userNameLabel.text = "\(model?.cardCreator?.firstName ?? "") \(model?.cardCreator?.lastName ?? "")"
        self.practiceTypeLabel.text = model?.practiceType?.title
        self.positionLabel.text = model?.position
        self.telephoneNumberLabel.text = model?.contactTelephone?.number
        self.descriptionLabel.text = model?.description
        self.locationLabel.text = "\(model?.city?.name ?? ""), \(model?.region?.name ?? "")"

    }

    
}
