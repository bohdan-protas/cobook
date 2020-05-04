//
//  SelectAlbumDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 5/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct SelectAlbumCellsConfigurator: CellConfiguratorType {

    var selectAlbumCellConfigurator: CellConfigurator<AlbumPreviewModel, SelectAlbumTableViewCell>?

    func reuseIdentifier(for item: AlbumPreviewModel, indexPath: IndexPath) -> String {
        return selectAlbumCellConfigurator?.reuseIdentifier ?? ""
    }

    func configuredCell(for item: AlbumPreviewModel, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        return selectAlbumCellConfigurator?.configuredCell(for: item, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }

    func registerCells(in tableView: UITableView) {}


}
