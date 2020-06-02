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
        var firstName: String?
        var lastName: String?
        var date: Date?
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
        case title(text: String)
    }

}

// MARK: - ArticleDetailsCellConfigutator

struct ArticleDetailsCellConfigutator: CellConfiguratorType {

    var headerConfigurator: CellConfigurator<ArticleDetails.HeaderModel, ArticleHeaderTableViewCell>?
    var descriptionCellConfigurator: CellConfigurator<ArticleDetails.DescriptionModel, ArticleDescriptionTableViewCell>?
    var creatorCellConfigurator: CellConfigurator<CardPreviewModel, CardPreviewTableViewCell>?
    var photoCollageConfigurator: CellConfigurator<Void?, PhotoCollageTableViewCell>?
    var articlePreviewConfigurator: CellConfigurator<ArticlePreviewModel, ArticlePreviewTableViewCell>?
    var titleCellConfigurator: CellConfigurator<String?, ArticleDetailsSectionTitleTableViewCell>?

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
        case .title:
            return titleCellConfigurator?.reuseIdentifier ?? ""
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
        case .title(let text):
            return titleCellConfigurator?.configuredCell(for: text, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
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

// MARK: - Configurator

extension ArticleDetailsPresenter {

    var dataSourceConfigurator: ArticleDetailsCellConfigutator {
        get {

            var configurator = ArticleDetailsCellConfigutator()

            configurator.articlePreviewConfigurator = CellConfigurator { (cell, model: ArticlePreviewModel, tableView, indexPath) -> ArticlePreviewTableViewCell in
                cell.articleTitle.text = model.title
                cell.articleImageView.setImage(withPath: model.image)
                return cell
            }

            configurator.photoCollageConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> PhotoCollageTableViewCell in
                cell.dataSource = self
                cell.delegate = self
                cell.prepareLayout()
                return cell
            }

            configurator.headerConfigurator = CellConfigurator { (cell, model: ArticleDetails.HeaderModel, tableView, indexPath) -> ArticleHeaderTableViewCell in
                cell.delegate = self

                let nameAbbr = "\(model.firstName?.first?.uppercased() ?? "") \(model.lastName?.first?.uppercased() ?? "")"
                let textPlaceholderImage = nameAbbr.image(size: cell.avatarImageView.frame.size)
                cell.avatarImageView.setImage(withPath: model.avatar, placeholderImage: textPlaceholderImage)
                cell.nameLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"

                cell.viewsCountLabel.text = model.viewersCount

                if let date = model.date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    cell.dateLabel.text = formatter.string(from: date)
                } else {
                    cell.dateLabel.text = ""
                }

                return cell
            }

            configurator.descriptionCellConfigurator = CellConfigurator { (cell, model: ArticleDetails.DescriptionModel, tableView, indexPath) -> ArticleDescriptionTableViewCell in
                cell.albumNameLabel.text = model.albumAvatarTitle
                cell.albumImageView.setImage(withPath: model.albumAvatarImage)
                cell.titleLabel.text = model.title
                cell.descriptionTextView.text = model.desctiption
                return cell
            }

            configurator.creatorCellConfigurator = CellConfigurator { (cell, model: CardPreviewModel, tableView, indexPath) -> CardPreviewTableViewCell in
                let nameAbbr = "\(model.firstName?.first?.uppercased() ?? "") \(model.lastName?.first?.uppercased() ?? "")"
                let textPlaceholderImage = nameAbbr.image(size: cell.titleImageView.frame.size)

                cell.titleImageView.setImage(withPath: model.image, placeholderImage: textPlaceholderImage)
                cell.proffesionLabel.text = model.profession
                cell.telephoneNumberLabel.text = model.telephone
                cell.companyNameLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"

                cell.selectionStyle = .none
                cell.accessoryView = nil
                return cell
            }

            configurator.titleCellConfigurator = CellConfigurator { (cell, model: String?, tableView, indexPath) -> ArticleDetailsSectionTitleTableViewCell in
                cell.titleLabel.text = model
                return cell
            }

            return configurator
        }
    }


}
