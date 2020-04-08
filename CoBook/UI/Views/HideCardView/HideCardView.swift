//
//  HideCardView.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class HideCardView: BaseFromNibView {

    var onHideTapped: (() -> Void)?

    @IBAction func hideCardTapped(_ sender: Any) {
        onHideTapped?()
    }

    override func getNib() -> UINib {
        return HideCardView.nib
    }

}
