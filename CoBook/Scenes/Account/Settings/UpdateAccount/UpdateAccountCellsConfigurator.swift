//
//  UpdateAccountCellsConfigurator.swift
//  CoBook
//
//  Created by protas on 5/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum UpdateAccount {

    enum Cell {
        case avatarManagment(model: CardAvatarManagmentCellModel)
        case title(text: String)
        case sectionSeparator
        case textField(model: TextFieldModel)
    }

    struct Details {
        var firstName: String?
        var lastName: String?
        var avatar: FileDataApiModel?
        var email: String?
    }
}

struct UpdateAccountCellsConfigutator: TableCellConfiguratorType {

    var titleConfigurator: TableCellConfigurator<String, SectionTitleTableViewCell>?
    var sectionSeparatorConfigurator: TableCellConfigurator<Void?, SectionHeaderTableViewCell>?
    var avatarManagmentConfigurator: TableCellConfigurator<CardAvatarManagmentCellModel, CardAvatarPhotoManagmentTableViewCell>?
    var textFieldConfigurator: TableCellConfigurator<TextFieldModel, TextFieldTableViewCell>?

    func reuseIdentifier(for item: UpdateAccount.Cell, indexPath: IndexPath) -> String {
        switch item {
        case .sectionSeparator:
            return sectionSeparatorConfigurator?.reuseIdentifier ?? ""
        case .title:
            return titleConfigurator?.reuseIdentifier ?? ""
        case .avatarManagment:
            return avatarManagmentConfigurator?.reuseIdentifier ?? ""
        case .textField:
            return textFieldConfigurator?.reuseIdentifier ?? ""
        }
    }

    func configuredCell(for item: UpdateAccount.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {

        case .avatarManagment(let model):
            return avatarManagmentConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .title(let text):
            return titleConfigurator?.configuredCell(for: text, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .sectionSeparator:
            return sectionSeparatorConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .textField(let model):
            return textFieldConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        }
    }

    func registerCells(in tableView: UITableView) {
        titleConfigurator?.registerCells(in: tableView)
        sectionSeparatorConfigurator?.registerCells(in: tableView)
        avatarManagmentConfigurator?.registerCells(in: tableView)
        textFieldConfigurator?.registerCells(in: tableView)
    }


}

extension UpdateAccountPresenter {

    var dataSourceConfigurator: UpdateAccountCellsConfigutator {
        get {
            var configurator = UpdateAccountCellsConfigutator()

            // sectionTitleConfigurator
            configurator.titleConfigurator = TableCellConfigurator { (cell, model: String, tableView, indexPath) -> SectionTitleTableViewCell in
                cell.titleLabel.text = model
                return cell
            }

            // sectionHeaderConfigurator
            configurator.sectionSeparatorConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> SectionHeaderTableViewCell in
                return cell
            }

            // textFieldConfigurator
            configurator.textFieldConfigurator = TableCellConfigurator { (cell, model: TextFieldModel, tableView, indexPath) -> TextFieldTableViewCell in
                cell.delegate = self
                cell.textField.text = model.text
                cell.textKeyPath = model.associatedKeyPath
                cell.textField.placeholder = model.placeholder
                cell.textField.keyboardType = model.keyboardType
                return cell
            }

            // avatarManagmentConfigurator
            configurator.avatarManagmentConfigurator = TableCellConfigurator { (cell, model: CardAvatarManagmentCellModel, tableView, indexPath) -> CardAvatarPhotoManagmentTableViewCell in
                cell.delegate = self.view
                cell.set(sourceType: .personalCard)
                if let imageData = model.imageData, let image = UIImage(data: imageData) {
                    cell.set(image: image)
                } else {
                    cell.set(imagePath: model.imagePath)
                }

                return cell
            }

            return configurator
        }
    }


}



