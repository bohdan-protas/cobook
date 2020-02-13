//
//  OnboardingPageCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 2/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol OnboardingPageCollectionViewCellDelegate: class {
    func actionButtonDidTapped(_ cell: OnboardingPageCollectionViewCell, actionType: Onboarding.ButtonActionType?)
}

class OnboardingPageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var actionButton: UIButton!

    var action: Onboarding.ButtonActionType?
    weak var delegate: OnboardingPageCollectionViewCellDelegate?

    @IBAction func actionButtonTapped(_ sender: Any) {
        delegate?.actionButtonDidTapped(self, actionType: action)
    }

    func fill(_ model: Onboarding.ViewModel) {
        self.titleImageView.image = model.image
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.subtitle
        self.actionButton.setTitle(model.actionTitle, for: .normal)
        self.action = model.action
    }


}
