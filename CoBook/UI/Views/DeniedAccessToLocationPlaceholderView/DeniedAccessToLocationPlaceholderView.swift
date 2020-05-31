 //
//  DiniedAccessToLocationPlaceholderView.swift
//  CoBook
//
//  Created by protas on 4/9/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class DeniedAccessToLocationPlaceholderView: BaseFromNibView {

    @Localized("Error.Map.accessDenied.title")
    @IBOutlet var titleLabel: UILabel!

    @Localized("Error.Map.accessDeniedButton.normalTitle")
    @IBOutlet var actionButton: UIButton!

    
    var onOpenSettingsHandler: (() -> Void)?

    override func getNib() -> UINib {
        return DeniedAccessToLocationPlaceholderView.nib
    }

    @IBAction func openSettingsTapped(_ sender: Any) {
        onOpenSettingsHandler?()
    }

}
