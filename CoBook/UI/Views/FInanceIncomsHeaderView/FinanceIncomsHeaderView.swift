//
//  FinanceIncomsHeaderView.swift
//  CoBook
//
//  Created by Bogdan Protas on 26.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol FinanceIncomsHeaderViewDelegate: class {
    func onExportSum(_ view: FinanceIncomsHeaderView)
}

class FinanceIncomsHeaderView: BaseFromNibView {

    @Localized("Financies.header.currentBallance")
    @IBOutlet var currentBallanceInfoLabel: UILabel!
    
    @IBOutlet var exportIncomsButton: LoaderDesignableButton!
    @IBOutlet var currentBallanceValueLabel: UILabel!
    @IBOutlet var maxSumForExportLabel: UILabel!
    @IBOutlet var averageSumOfExportsLabel: UILabel!
    @IBOutlet var topCorneredView: UIView!
    
    weak var delegate: FinanceIncomsHeaderViewDelegate?
    
    // MARK: Lifecycle
    
    override func getNib() -> UINib {
        return FinanceIncomsHeaderView.nib
    }
    
    override func setupLayout() {
        topCorneredView.clipsToBounds = true
        topCorneredView.layer.cornerRadius = 10
        topCorneredView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    // MARK: - Actions
    
    @IBAction func exportButtonTapped(_ sender: UIButton) {
        delegate?.onExportSum(self)
    }
    

}
