//
//  CardsOverviewDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CardsOverviewViewDataSourceConfigurator: CellConfiguratorType {

    weak var presenter: CardsOverviewViewPresenter?

    // MARK: Configurators

    var cardItemCellConfigurator: CellConfigurator<CardItemViewModel?, CardItemTableViewCell>
    var mapCellConfigurator: CellConfigurator<Void?, MapTableViewCell>

    // MARK: - Initializer

    init(presenter: CardsOverviewViewPresenter) {
        self.presenter = presenter

        cardItemCellConfigurator = CellConfigurator { (cell, model: CardItemViewModel?, tableView, indexPath) -> CardItemTableViewCell in
            cell.avatarImageView.setTextPlaceholderImage(withPath: model?.avatarPath, placeholderText: model?.nameAbbreviation)
            cell.type = model?.type
            cell.nameLabel.text = "\(model?.firstName ?? "") \(model?.lastName ?? "")"
            cell.professionLabel.text = model?.profession
            cell.telNumberLabel.text = model?.telephoneNumber
            return cell
        }

        mapCellConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> MapTableViewCell in
            cell.heightConstraint.constant = tableView.frame.height - 58
            cell.mapView.settings.myLocationButton = true
            cell.mapView.isMyLocationEnabled = true
            cell.delegate = presenter
            return cell
        }

    }

    // MARK: - Cell configurator

    func reuseIdentifier(for item: CardsOverview.Items, indexPath: IndexPath) -> String {
        switch item {
        case .cardItem:
            return cardItemCellConfigurator.reuseIdentifier
        case .map:
            return mapCellConfigurator.reuseIdentifier
        }
    }

    func configuredCell(for item: CardsOverview.Items, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .cardItem(let model):
            return cardItemCellConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .map:
            return mapCellConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
        }
    }

    func registerCells(in tableView: UITableView) {
        cardItemCellConfigurator.registerCells(in: tableView)
        mapCellConfigurator.registerCells(in: tableView)
    }


}
