//
//  EditCardView.swift
//  CoBook
//
//  Created by protas on 3/23/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class EditCardView: BaseFromNibView {

    @Localized("Button.edit.normalTitle")
    @IBOutlet var editButton: LoaderDesignableButton!
    
    var onEditTapped: (() -> Void)?

    override func getNib() -> UINib {
        return EditCardView.nib
    }

    @IBAction func editButtonTapped(_ sender: UIButton) {
        onEditTapped?()
    }

}
