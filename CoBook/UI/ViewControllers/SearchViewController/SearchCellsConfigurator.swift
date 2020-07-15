//
//  SearchCellsConfigurator.swift
//  CoBook
//
//  Created by protas on 6/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum SearchContent {

    enum Item {
        case practice(model: PracticeModel)
        case company(model: CompanyApiModel)
    }


}

struct SearchCellsConfigurator: TableCellConfiguratorType {

    var practiceConfigurator: TableCellConfigurator<PracticeModel, FilterItemTableViewCell>?
    var companiesConfigurator: TableCellConfigurator<CompanyApiModel, FilterItemTableViewCell>?
    
    func reuseIdentifier(for item: SearchContent.Item, indexPath: IndexPath) -> String {
        switch item {
        case .practice:
            return practiceConfigurator?.reuseIdentifier ?? ""
        case .company:
            return companiesConfigurator?.reuseIdentifier ?? ""
        }
    }

    func configuredCell(for item: SearchContent.Item, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .practice(let model):
            return practiceConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .company(model: let model):
            return companiesConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        }
    }

    func registerCells(in tableView: UITableView) {
        practiceConfigurator?.registerCells(in: tableView)
        companiesConfigurator?.registerCells(in: tableView)
    }


}
