//
//  CardsOverviewDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/8/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CardsOverviewViewDataSourceConfigurator: TableCellConfiguratorType {

    var cardItemCellConfigurator: TableCellConfigurator<CardItemViewModel, CardItemTableViewCell>?
    var mapCellConfigurator: TableCellConfigurator<Void?, MapTableViewCell>?
    var postPreviewConfigurator: TableCellConfigurator<PostPreview.Section?, AlbumPreviewItemsTableViewCell>?

    // MARK: - Cell configurator

    func reuseIdentifier(for item: CardsOverview.Items, indexPath: IndexPath) -> String {
        switch item {
        case .cardItem:
            return cardItemCellConfigurator?.reuseIdentifier ?? ""
        case .map:
            return mapCellConfigurator?.reuseIdentifier ?? ""
        case .postPreview:
            return postPreviewConfigurator?.reuseIdentifier ?? ""
        }
    }

    func configuredCell(for item: CardsOverview.Items, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {

        case .cardItem(let model):
            return cardItemCellConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .map:
            return mapCellConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .postPreview(let model):
             return postPreviewConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        }
    }

    func registerCells(in tableView: UITableView) {
        cardItemCellConfigurator?.registerCells(in: tableView)
        mapCellConfigurator?.registerCells(in: tableView)
        postPreviewConfigurator?.registerCells(in: tableView)
    }


}

// MARK: - Data source configurator fabric

extension CardsOverviewViewPresenter {

    var dataSourceConfigurator: CardsOverviewViewDataSourceConfigurator {
        get {
            let dataSourceConfigurator = CardsOverviewViewDataSourceConfigurator()

            // cardItemCellConfigurator
            dataSourceConfigurator.cardItemCellConfigurator = TableCellConfigurator { (cell, model: CardItemViewModel, tableView, indexPath) -> CardItemTableViewCell in
                cell.delegate = self.view
                cell.avatarImageView.setImage(withPath: model.avatarPath, placeholderImage: model.nameAbbreviation?.image(size: cell.avatarImageView.frame.size))
                
                cell.type = model.type
                switch model.type {
                case .personal:
                    cell.nameLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"
                case .business:
                    cell.nameLabel.text = model.companyName
                }

                cell.professionLabel.text = model.profession
                cell.telNumberLabel.text = model.telephoneNumber
                cell.saveButton.isSelected = model.isSaved
                return cell
            }

            // mapCellConfigurator
            dataSourceConfigurator.mapCellConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> MapTableViewCell in
                cell.heightConstraint.constant = tableView.frame.height - 58 - AlbumPreviewItemsTableViewCell.height
                cell.mapView.settings.myLocationButton = true
                cell.mapView.isMyLocationEnabled = true
                cell.delegate = self.view
                return cell
            }

            dataSourceConfigurator.postPreviewConfigurator = TableCellConfigurator { (cell, model: PostPreview.Section?, tableView, indexPath) -> AlbumPreviewItemsTableViewCell in
                cell.dataSourceID = model?.dataSourceID
                cell.delegate = self
                cell.dataSource = self
                cell.collectionView.reloadData()
                return cell
            }

            return dataSourceConfigurator

        }
    }


}
