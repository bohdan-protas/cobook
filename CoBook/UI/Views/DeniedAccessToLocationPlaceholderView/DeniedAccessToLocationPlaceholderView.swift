 //
//  DiniedAccessToLocationPlaceholderView.swift
//  CoBook
//
//  Created by protas on 4/9/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class DeniedAccessToLocationPlaceholderView: BaseFromNibView {

    var onOpenSettingsHandler: (() -> Void)?

    override func getNib() -> UINib {
        return DeniedAccessToLocationPlaceholderView.nib
    }

    @IBAction func openSettingsTapped(_ sender: Any) {
        onOpenSettingsHandler?()
    }

}
