//
//  AccountHeaderView.swift
//  CoBook
//
//  Created by protas on 3/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class AccountHeaderView: BaseFromNibView {

    // MAKR: IBOutlets
    @IBOutlet var bgImageView: UIImageView!
    @IBOutlet var userAvatarImageView: DesignableTextPlaceholderImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var telephoneNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var settingsButton: UIButton!

    // MARK: Actions
    @IBAction func settingsButtonTapped(_ sender: Any) {

    }

    // NARK: Lifecycle
    override func getNib() -> UINib {
        return AccountHeaderView.nib
    }

    func fill(with profile: Profile?) {
        self.userAvatarImageView.textPlaceholder = "\(profile?.firstName?.first?.uppercased() ?? "")\(profile?.lastName?.first?.uppercased() ?? "")"
        self.userNameLabel.text = "\(profile?.firstName ?? "") \(profile?.lastName ?? "")"
        self.telephoneNumberLabel.text = profile?.telephone.number
        self.emailLabel.text = profile?.email.address

    }

}
