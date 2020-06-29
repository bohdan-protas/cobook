//
//  AccountDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


struct AccountDataSourceConfigurator: TableCellConfiguratorType {
    
    let sectionTitleConfigurator: TableCellConfigurator<String, SectionTitleTableViewCell>
    let sectionHeaderConfigurator: TableCellConfigurator<Void?, SectionHeaderTableViewCell>
    let accountItemCellConfigurator: TableCellConfigurator<Account.AccountMenuItemModel, AccountItemTableViewCell>
    let accountHeaderCellConfigurator: TableCellConfigurator<Account.UserInfoHeaderModel?, AccountHeaderTableViewCell>
    let cardPreviewConfigurator: TableCellConfigurator<CardPreviewModel, CardPreviewTableViewCell>

    func reuseIdentifier(for item: Account.Item, indexPath: IndexPath) -> String {
        switch item {
        case .title:
            return sectionTitleConfigurator.reuseIdentifier
        case .sectionHeader:
            return sectionHeaderConfigurator.reuseIdentifier
        case .userInfoHeader:
            return accountHeaderCellConfigurator.reuseIdentifier
        case .menuItem:
            return accountItemCellConfigurator.reuseIdentifier
        case .personalCardPreview, .businessCardPreview:
            return cardPreviewConfigurator.reuseIdentifier
        }
    }

    func configuredCell(for item: Account.Item, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .title(let text):
            return sectionTitleConfigurator.configuredCell(for: text, tableView: tableView, indexPath: indexPath)
        case .sectionHeader:
            return sectionHeaderConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
        case .userInfoHeader(let model):
            return accountHeaderCellConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .menuItem(let model):
            return accountItemCellConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .personalCardPreview(let model):
            return cardPreviewConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .businessCardPreview(let model):
            return cardPreviewConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        }
    }

    func registerCells(in tableView: UITableView) {
        sectionTitleConfigurator.registerCells(in: tableView)
        sectionHeaderConfigurator.registerCells(in: tableView)
        accountItemCellConfigurator.registerCells(in: tableView)
        accountHeaderCellConfigurator.registerCells(in: tableView)
        cardPreviewConfigurator.registerCells(in: tableView)
    }

}

extension AccountPresenter {

    var dataSourceConfigurator: AccountDataSourceConfigurator {

        get {
            let sectionTitleConfigurator = TableCellConfigurator { (cell, model: String, tableView, indexPath) -> SectionTitleTableViewCell in
                cell.titleLabel.text = model
                return cell
            }

            let sectionHeaderConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> SectionHeaderTableViewCell in
                return cell
            }

            let  accountItemCellConfigurator = TableCellConfigurator { (cell, model: Account.AccountMenuItemModel, tableView, indexPath) -> AccountItemTableViewCell in
                cell.titleLabel.text = model.title
                cell.typeImageView.image = model.image
                return cell
            }

            let accountHeaderCellConfigurator = TableCellConfigurator { (cell, model: Account.UserInfoHeaderModel?, tableView, indexPath) -> AccountHeaderTableViewCell in
                cell.delegate = self.view
                let nameAbbr = "\(model?.firstName?.first?.uppercased() ?? "") \(model?.lastName?.first?.uppercased() ?? "")"
                let textPlaceholderImage = nameAbbr.image(size: cell.avatarTextPlaceholderImageView.frame.size)
                cell.avatarTextPlaceholderImageView.setImage(withPath: model?.avatarUrl, placeholderImage: textPlaceholderImage)
                cell.userNameLabel.text = "\(model?.firstName ?? "") \(model?.lastName ?? "")"
                cell.emailLabel.text = model?.email
                cell.telephoneNumberLabel.text = model?.telephone
                return cell
            }

            let cardPreviewConfigurator = TableCellConfigurator { (cell, model: CardPreviewModel, tableView, indexPath) -> CardPreviewTableViewCell in
                let nameAbbr = "\(model.firstName?.first?.uppercased() ?? "") \(model.lastName?.first?.uppercased() ?? "")"
                let textPlaceholderImage = nameAbbr.image(size: cell.titleImageView.frame.size)

                cell.titleImageView.setImage(withPath: model.image, placeholderImage: textPlaceholderImage)
                cell.proffesionLabel.text = model.profession
                cell.telephoneNumberLabel.text = model.telephone
                cell.titleLabel.text = "\(model.firstName ?? "") \(model.lastName ?? "")"

                switch model.publishStatus {
                case .none:
                    cell.detailLabel.text = ""
                    cell.detailLabel.isHidden = true
                case .some(let value):
                    cell.detailLabel.text = value.description
                    cell.detailLabel.textColor = value.color
                    cell.detailLabel.isHidden = false
                }
                
                return cell
            }


            return AccountDataSourceConfigurator(sectionTitleConfigurator: sectionTitleConfigurator,
                                                 sectionHeaderConfigurator: sectionHeaderConfigurator,
                                                 accountItemCellConfigurator: accountItemCellConfigurator,
                                                 accountHeaderCellConfigurator: accountHeaderCellConfigurator,
                                                 cardPreviewConfigurator: cardPreviewConfigurator)
        }

    }

}
