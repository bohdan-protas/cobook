//
//  FinanceStatisticsHeaderView.swift
//  CoBook
//
//  Created by Bogdan Protas on 30.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class FinanceStatisticsHeaderView: BaseFromNibView {

    @Localized("Finance.Statistics.appDownloaded.title")
    @IBOutlet var appDownloadedTitleLabel: UILabel!
    @IBOutlet var appDownloadedValueLabel: UILabel!
    
    @Localized("Finance.Statistics.businessAccountCreated.title")
    @IBOutlet var businessAccountCreatedTitleLabel: UILabel!
    @IBOutlet var businessAccountValueLabel: UILabel!
    
    override func getNib() -> UINib {
        return FinanceStatisticsHeaderView.nib
    }
    
    
}
