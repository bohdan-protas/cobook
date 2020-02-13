//
//  OnboardingPageCollectionViewCell.swift
//  CoBook
//
//  Created by protas on 2/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class OnboardingPageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    func fill(_ model: Onboarding.ViewModel) {
        self.titleImageView.image = model.image
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.subtitle
    }


}
