//
//  CreateServiceDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct CreateServiceDataSourceConfigurator: CellConfiguratorType {

    func reuseIdentifier(for item: Service.CreateItem, indexPath: IndexPath) -> String {
        return ""
    }

    func configuredCell(for item: Service.CreateItem, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()

    }

    func registerCells(in tableView: UITableView) {

    }


}
