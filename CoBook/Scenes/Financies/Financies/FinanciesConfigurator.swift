//
//  FinanciesConfigurator.swift
//  CoBook
//
//  Created by Bogdan Protas on 26.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum Financies {
    
    enum Item {
        case bonusHistoryItem(model: Model.BonusHistoryItem)
    }
    
    enum Model {
        
        struct BonusHistoryItem {
            var id: Int?
            var type: CardType?
            var telephone: String?
            var cardCreator: CardCreatorApiModel?
            var companyName: String?
            var avatarURL: String?
            var practiceType: String?
            var moneyIncome: Int?
        }
        
    }

}

struct FinanciesCellsConfigurator: TableCellConfiguratorType {
    
    let bonusHistoryItemCellConfigurator: TableCellConfigurator<Financies.Model.BonusHistoryItem, CardPreviewTableViewCell>
    
    func reuseIdentifier(for item: Financies.Item, indexPath: IndexPath) -> String {
        switch item {
        case .bonusHistoryItem:
            return bonusHistoryItemCellConfigurator.reuseIdentifier
        }
    }

    func configuredCell(for item: Financies.Item, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .bonusHistoryItem(let model):
            return bonusHistoryItemCellConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        }
    }
    
    func registerCells(in tableView: UITableView) {
        bonusHistoryItemCellConfigurator.registerCells(in: tableView)
    }
    
    
}
