//
//  SwitcherHeaderView.swift
//  CoBook
//
//  Created by Bogdan Protas on 30.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SwitcherHeaderView: BaseFromNibView {
    
    @IBOutlet var containerView: DesignableView!
    
    @Localized("Finance.Statistics.ratingOfUserBonuses.title")
    @IBOutlet var titleLabel: UILabel!
    
    @Localized("Finance.Statistics.ratingOfUserBonuses.action.inRegion")
    @IBOutlet var firstActionButton: DesignableButton!
    
    @Localized("Finance.Statistics.ratingOfUserBonuses.action.avarage")
    @IBOutlet var secondActionButton: DesignableButton!
    
    var firstActionHandler: (() -> Void)?
    var secondActionHandler: (() -> Void)?
    
    override func setupLayout() {
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    override func getNib() -> UINib {
        return SwitcherHeaderView.nib
    }
    
    @IBAction func firstActionButtonTapped(_ sender: UIButton) {
        sender.isSelected = true
        secondActionButton.isSelected = false
        firstActionHandler?()
    }
    
    @IBAction func secondActionButtonTapped(_ sender: UIButton) {
        sender.isSelected = true
        firstActionButton.isSelected = false
        secondActionHandler?()
    }
    
}
