//
//  BusinessCardDetailsDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct BusinessCardDetailsDataSourceConfigurator: CellConfiguratorType {

    // MARK: Properties
    weak var presenter: BusinessCardDetailsPresenter?

    // MARK: Initializer
    init(presenter: BusinessCardDetailsPresenter) {
        self.presenter = presenter
    }

    func reuseIdentifier(for item: PersonalCardDetails.Cell, indexPath: IndexPath) -> String {
        return ""
    }

    func configuredCell(for item: PersonalCardDetails.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func registerCells(in tableView: UITableView) {

    }
}
