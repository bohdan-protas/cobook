//
//  HideCardView.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class HideCardView: BaseFromNibView {

    @Localized("Card.hideButton.normalTitle")
    @IBOutlet var hideQuestionLabel: UILabel!

    @Localized("Card.hideLabel.text")
    @IBOutlet var hideButton: UILabel!

    var onHideTapped: (() -> Void)?

    @IBAction func hideCardTapped(_ sender: Any) {
        onHideTapped?()
    }

    override func getNib() -> UINib {
        return HideCardView.nib
    }

}
