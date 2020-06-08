//
//  FilterDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 6/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum Filter {

    enum Items {
        case title(model: ActionTitleModel)
        case sectionSeparator
        case itemsPreview(dataSourceID: String?)
    }

    enum SectionAccessoryIndex: Int {
        case interests
        case practicies
    }


}


struct FilterCellsConfigurator: CellConfiguratorType {

    var titleConfigurator: CellConfigurator<ActionTitleModel, ActionTitleTableViewCell>
    var sectionSeparatorConfigurator: CellConfigurator<Void?, SectionHeaderTableViewCell>
    var itemsPreviewListConfigurator: CellConfigurator<String?, InterestsSelectionTableViewCell>

    func reuseIdentifier(for item: Filter.Items, indexPath: IndexPath) -> String {
        switch item {
        case .title:
            return titleConfigurator.reuseIdentifier
        case .sectionSeparator:
            return sectionSeparatorConfigurator.reuseIdentifier
        case .itemsPreview:
            return itemsPreviewListConfigurator.reuseIdentifier
        }
    }

    func configuredCell(for item: Filter.Items, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .title(let model):
            return titleConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .sectionSeparator:
            return sectionSeparatorConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
        case .itemsPreview(let dataSourceID):
            return itemsPreviewListConfigurator.configuredCell(for: dataSourceID, tableView: tableView, indexPath: indexPath)
        }
    }

    func registerCells(in tableView: UITableView) {
        titleConfigurator.registerCells(in: tableView)
        sectionSeparatorConfigurator.registerCells(in: tableView)
        itemsPreviewListConfigurator.registerCells(in: tableView)
    }


}

extension FilterPresenter {

    var tableDataSourceConfigurator: FilterCellsConfigurator {
        get {

            // titleConfigurator
            let titleConfigurator = CellConfigurator { (cell, model: ActionTitleModel, tableView, indexPath) -> ActionTitleTableViewCell in
                cell.titleLabel.text = model.title
                cell.countLabel.text = "\( model.counter ?? 0)"
                cell.actionButton.setTitle(model.actionTitle, for: .normal)
                cell.actionHandler = model.actionHandler
                return cell
            }

            // sectionHeaderConfigurator
            let sectionHeaderConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> SectionHeaderTableViewCell in
                return cell
            }

            // sectionHeaderConfigurator
            let itemsConfigurator = CellConfigurator { (cell, model: String?, tableView, indexPath) -> InterestsSelectionTableViewCell in
                cell.dataSourceIdentifier = model
                cell.dataSource = self
                cell.delegate = self
                cell.topConstraint.constant = 0
                cell.bottomConstraint.constant = 0
                cell.leftConftraint.constant = 16
                cell.rightConstraint.constant = 16
                cell.heightConstraint.constant = 200
                cell.reload()
                return cell
            }

            return FilterCellsConfigurator(titleConfigurator: titleConfigurator,
                                           sectionSeparatorConfigurator: sectionHeaderConfigurator,
                                           itemsPreviewListConfigurator: itemsConfigurator)
        }
    }


}
