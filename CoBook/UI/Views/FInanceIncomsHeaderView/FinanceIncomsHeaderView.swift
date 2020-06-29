//
//  FinanceIncomsHeaderView.swift
//  CoBook
//
//  Created by Bogdan Protas on 26.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class FinanceIncomsHeaderView: BaseFromNibView {

    @Localized("Financies.header.currentBallance") @IBOutlet var currentBallanceInfoLabel: UILabel!
    @Localized("Financies.header.exportOnCard") @IBOutlet var exportIncomsButton: LoaderDesignableButton!
    
    @IBOutlet var currentBallanceValueLabel: UILabel!
    @IBOutlet var maxSumForExportLabel: UILabel!
    @IBOutlet var averageSumOfExportsLabel: UILabel!
    @IBOutlet var topCorneredView: UIView!
    
    // MARK: Lifecycle
    
    override func getNib() -> UINib {
        return FinanceIncomsHeaderView.nib
    }
    
    override func setupLayout() {
        topCorneredView.clipsToBounds = true
        topCorneredView.layer.cornerRadius = 10
        topCorneredView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

}
