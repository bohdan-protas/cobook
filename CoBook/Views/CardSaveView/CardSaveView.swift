//
//  CardSaveView.swift
//  CoBook
//
//  Created by protas on 3/12/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CardSaveView: BaseFromNibView {

    @IBOutlet var saveButton: LoaderButton!
    @IBOutlet var topShadowView: UIView!

    override func getNib() -> UINib {
        return CardSaveView.nib
    }
    

}
