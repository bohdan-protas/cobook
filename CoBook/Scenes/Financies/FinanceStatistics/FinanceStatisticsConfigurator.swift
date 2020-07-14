//
//  FinanceStatisticsConfigurator.swift
//  CoBook
//
//  Created by Bogdan Protas on 02.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct FinanceStatisticsConfigurator: TableCellConfiguratorType {
    
    let cardHistoryPreviewCellConfigurator: TableCellConfigurator<LeaderboardStatAPIModel, CardPreviewTableViewCell>
    
    func reuseIdentifier(for item: FinanceStatistics.Item, indexPath: IndexPath) -> String {
        switch item {
        case .ratingItem:
            return cardHistoryPreviewCellConfigurator.reuseIdentifier
        }
    }

    func configuredCell(for item: FinanceStatistics.Item, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .ratingItem(let model):
            return cardHistoryPreviewCellConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        }
    }
    
    func registerCells(in tableView: UITableView) {
        cardHistoryPreviewCellConfigurator.registerCells(in: tableView)
    }
    
    
}
