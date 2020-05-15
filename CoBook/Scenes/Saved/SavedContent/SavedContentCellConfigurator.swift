//
//  SavedContentCellConfigurator.swift
//  CoBook
//
//  Created by protas on 5/14/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum SavedContent {

    enum Cell {
        case cardItem(model: CardItemViewModel)
        case map
    }

    enum SectionAccessoryIndex: Int {
        case post
        case card
    }

    enum BarItemIndex: Int {
        case allCards, personalCards, businessCards, inMyRegionCards
    }

}

class SavedContentCellConfigurator: CellConfiguratorType {

    var cardItemCellConfigurator: CellConfigurator<CardItemViewModel, ContactableCardItemTableViewCell>?
    var mapCellConfigurator: CellConfigurator<Void?, MapTableViewCell>?

    // MARK: - Cell configurator

    func reuseIdentifier(for item: SavedContent.Cell, indexPath: IndexPath) -> String {
        switch item {
        case .cardItem:
            return cardItemCellConfigurator?.reuseIdentifier ?? ""
        case .map:
            return mapCellConfigurator?.reuseIdentifier ?? ""
        }
    }

    func configuredCell(for item: SavedContent.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .cardItem(let model):
            return cardItemCellConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .map:
            return mapCellConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        }
    }

    func registerCells(in tableView: UITableView) {
        cardItemCellConfigurator?.registerCells(in: tableView)
        mapCellConfigurator?.registerCells(in: tableView)
    }


}

// MARK: - Data source configurator fabric

extension SavedContentPresenter {

    var dataSourceConfigurator: SavedContentCellConfigurator {
        get {

            let dataSourceConfigurator = SavedContentCellConfigurator()

            // cardItemCellConfigurator
            dataSourceConfigurator.cardItemCellConfigurator = CellConfigurator { (cell, model: CardItemViewModel, tableView, indexPath) -> ContactableCardItemTableViewCell in
                //cell.delegate = self.view
                let textPlaceholderImage = model.nameAbbreviation?.image(size: cell.avatarImageView.frame.size)
                cell.avatarImageView.setImage(withPath: model.avatarPath, placeholderImage: textPlaceholderImage)
                cell.type = model.type

                switch model.type {
                case .personal:
                    cell.headerLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"
                case .business:
                    cell.headerLabel.text = model.companyName
                }

                cell.bodyLabel.text = model.profession
                cell.telNumberLabel.text = model.telephoneNumber
                cell.saveButton.isSelected = model.isSaved
                return cell
            }

            // mapCellConfigurator
            dataSourceConfigurator.mapCellConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> MapTableViewCell in
                cell.heightConstraint.constant = tableView.frame.height - 58
                cell.mapView.settings.myLocationButton = true
                cell.mapView.isMyLocationEnabled = true
                //cell.delegate = self
                return cell
            }

            return dataSourceConfigurator

        }
    }


}
