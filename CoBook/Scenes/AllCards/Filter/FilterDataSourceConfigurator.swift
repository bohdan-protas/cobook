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
        case practicies
    }

}

struct FilterCellsConfigurator: CellConfiguratorType {

    var titleConfigurator: CellConfigurator<ActionTitleModel, SavedContentTitleTableViewCell>
    var sectionHeaderConfigurator: CellConfigurator<Void?, SectionHeaderTableViewCell>
    var interestsListConfigurator: CellConfigurator<Void?, InterestsSelectionTableViewCell>

    func reuseIdentifier(for item: Filter.Items, indexPath: IndexPath) -> String {
        return ""
    }

    func configuredCell(for item: Filter.Items, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func registerCells(in tableView: UITableView) {

    }


}
