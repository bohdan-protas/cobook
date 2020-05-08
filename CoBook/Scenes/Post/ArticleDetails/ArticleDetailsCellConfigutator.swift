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

    enum SectionAccessory: Int {
        case details, list
    }

    struct HeaderModel {
        var avatar: String?
        var name: String?
        var date: String?
        var viewersCount: String?
    }

    struct DescriptionModel {
        var title: String?
        var desctiption: String?
        var albumAvatarImage: String?
        var albumAvatarTitle: String?
    }

    enum Cell {
        case header(model: HeaderModel)
        case descriptionDetails(model: DescriptionModel)
        case creator(model: CardPreviewModel)
        case photoCollage
        case articlePreview(model: ArticlePreviewModel)
    }

}

// MARK: - ArticleDetailsCellConfigutator

struct ArticleDetailsCellConfigutator: CellConfiguratorType {

    var headerConfigurator: CellConfigurator<ArticleDetails.HeaderModel, ArticleHeaderTableViewCell>?
    var descriptionCellConfigurator: CellConfigurator<ArticleDetails.DescriptionModel, ArticleDescriptionTableViewCell>?
    var creatorCellConfigurator: CellConfigurator<CardPreviewModel, CardPreviewTableViewCell>?
    var photoCollageConfigurator: CellConfigurator<Void?, PhotoCollageTableViewCell>?
    var articlePreviewConfigurator: CellConfigurator<ArticlePreviewModel, ArticlePreviewTableViewCell>?

    func reuseIdentifier(for item: ArticleDetails.Cell, indexPath: IndexPath) -> String {
        switch item {
        case .header:
            return headerConfigurator?.reuseIdentifier ?? ""
        case .descriptionDetails:
            return descriptionCellConfigurator?.reuseIdentifier ?? ""
        case .creator:
            return creatorCellConfigurator?.reuseIdentifier ?? ""
        case .photoCollage:
            return photoCollageConfigurator?.reuseIdentifier ?? ""
        case .articlePreview:
            return articlePreviewConfigurator?.reuseIdentifier ?? ""
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
        case .photoCollage:
            return photoCollageConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .articlePreview(let model):
            return articlePreviewConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        }
    }

    func registerCells(in tableView: UITableView) {
        headerConfigurator?.registerCells(in: tableView)
        descriptionCellConfigurator?.registerCells(in: tableView)
        creatorCellConfigurator?.registerCells(in: tableView)
        photoCollageConfigurator?.registerCells(in: tableView)
        articlePreviewConfigurator?.registerCells(in: tableView)
    }


}
