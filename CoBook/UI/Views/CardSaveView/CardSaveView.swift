//
//  CardSaveView.swift
//  CoBook
//
//  Created by protas on 3/12/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CardSaveView: BaseFromNibView {

    @IBOutlet var saveButton: LoaderDesignableButton!
    @IBOutlet var topShadowView: UIView!

    var onSaveTapped: (() -> Void)?

    override func getNib() -> UINib {
        return CardSaveView.nib
    }
    
    @IBAction func onSaveButtonTapped(_ sender: LoaderDesignableButton) {
        onSaveTapped?()
    }

}
