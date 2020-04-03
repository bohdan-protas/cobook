//
//  PersonalCardUserInfoTableViewCell.swift
//  CoBook
//
//  Created by protas on 3/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

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
        avatarImageView.cancelImageRequest()
        userNameLabel.text = ""
        practiceTypeLabel.text = ""
        positionLabel.text = ""
        telephoneNumberLabel.text = ""
        descriptionLabel.text = ""
        locationLabel.text = ""

    }

//    func fill(with model: CardDetailsAPIResponseData?) {
//        self.avatarImageView.setImage(withPath: model?.avatar?.sourceUrl,
//                                      placeholderText: "\(model?.cardCreator?.firstName?.first?.uppercased() ?? "") \(model?.cardCreator?.lastName?.first?.uppercased() ?? "")")
//        self.userNameLabel.text = "\(model?.cardCreator?.firstName ?? "") \(model?.cardCreator?.lastName ?? "")"
//        self.practiceTypeLabel.text = model?.practiceType?.title
//        self.positionLabel.text = model?.position
//        self.telephoneNumberLabel.text = model?.contactTelephone?.number
//        self.descriptionLabel.text = model?.description
//        self.locationLabel.text = "\(model?.city?.name ?? ""), \(model?.region?.name ?? "")"
//
//    }

    
}
