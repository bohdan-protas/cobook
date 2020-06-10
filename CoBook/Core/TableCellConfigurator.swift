//
//  CellConfigurator.swift
//  CoBook
//
//  Created by protas on 4/1/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol CellConfiguratorType {
    associatedtype Item
    associatedtype Cell: UITableViewCell

    func reuseIdentifier(for item: Item, indexPath: IndexPath) -> String
    func configuredCell(for item: Item, tableView: UITableView, indexPath: IndexPath) -> Cell
    func registerCells(in tableView: UITableView)
}

struct CellConfigurator<Item, Cell: UITableViewCell>: CellConfiguratorType {
    typealias Configurator = (Cell, Item, UITableView, IndexPath) -> Cell

    let configurator: Configurator
    let reuseIdentifier = Cell.identifier

    func reuseIdentifier(for item: Item, indexPath: IndexPath) -> String {
        return reuseIdentifier
    }

    func configure(cell: Cell, item: Item, tableView: UITableView, indexPath: IndexPath) -> Cell {
        return configurator(cell, item, tableView, indexPath)
    }

    func registerCells(in tableView: UITableView) {
        tableView.register(Cell.nib, forCellReuseIdentifier: Cell.identifier)
    }

    func configuredCell(for item: Item, tableView: UITableView, indexPath: IndexPath) -> Cell {
        let reuseIdentifier = self.reuseIdentifier(for: item, indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Cell
        return self.configure(cell: cell, item: item, tableView: tableView, indexPath: indexPath)
    }
}



