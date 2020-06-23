//
//  CardStatisticsConfigurator.swift
//  CoBook
//
//  Created by Bogdan Protas on 21.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct CardStatisticsCellsConfigurator: TableCellConfiguratorType {
    
    let cardStatisticConfigurator: TableCellConfigurator<CardStatisticInfoApiModel, CardStatisticItemTableViewCell>
    
    func reuseIdentifier(for item: CardStatistics.Item, indexPath: IndexPath) -> String {
        switch item {
        case .card:
            return cardStatisticConfigurator.reuseIdentifier
        }
    }

    func configuredCell(for item: CardStatistics.Item, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .card(let model):
            return cardStatisticConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        }
    }

    func registerCells(in tableView: UITableView) {
        cardStatisticConfigurator.registerCells(in: tableView)
    }
    
}
