//
//  ArticleDetailsCellConfigutator.swift
//  CoBook
//
//  Created by protas on 5/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

// MARK: - ArticleDetails

enum ArticleDetails {

    struct HeaderModel {
        var name: String?
        var date: String?
        var viewersCount: Int?
    }

    struct DescriptionModel {
        var title: String?
        var desctiption: String?
        var avatarImage: String?
        var avatarTitle: String?
    }

    enum Cell {
        case header(model: HeaderModel)
        case descriptionDetails(model: DescriptionModel)
        case creator(model: CardPreviewModel)
    }

}

// MARK: - ArticleDetailsCellConfigutator

struct ArticleDetailsCellConfigutator: CellConfiguratorType {

    var headerConfigurator: CellConfigurator<ArticleDetails.HeaderModel, ArticleHeaderTableViewCell>?
    var descriptionCellConfigurator: CellConfigurator<ArticleDetails.DescriptionModel, ArticleHeaderTableViewCell>?
    let creatorCellConfigurator: CellConfigurator<CardPreviewModel, CardPreviewTableViewCell>?

    func reuseIdentifier(for item: ArticleDetails.Cell, indexPath: IndexPath) -> String {
        switch item {
        case .header:
            return headerConfigurator?.reuseIdentifier ?? ""
        case .descriptionDetails:
            return descriptionCellConfigurator?.reuseIdentifier ?? ""
        case .creator:
            return creatorCellConfigurator?.reuseIdentifier ?? ""
        }
    }

    func configuredCell(for item: ArticleDetails.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .header(let model):
            return headerConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .descriptionDetails(let model):
            return descriptionCellConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .creator(let model):
            return creatorCellConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        }
    }

    func registerCells(in tableView: UITableView) {
        headerConfigurator?.registerCells(in: tableView)
        descriptionCellConfigurator?.registerCells(in: tableView)
        creatorCellConfigurator?.registerCells(in: tableView)
    }


}
