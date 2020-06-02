//
//  ChangePasswordCellsConfigurator.swift
//  CoBook
//
//  Created by protas on 5/20/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum ChangePassword {

    enum Cell {
        case title(text: String)
        case textField(model: TextFieldModel)
    }

    struct Details {
        var oldPassword: String?
        var newPassword: String?
        var repeatPassword: String?
    }

}

struct ChangePasswordCellsConfigutator: CellConfiguratorType {

    var titleConfigurator: CellConfigurator<String, SectionTitleTableViewCell>?
    var textFieldConfigurator: CellConfigurator<TextFieldModel, TextFieldTableViewCell>?

    func reuseIdentifier(for item: ChangePassword.Cell, indexPath: IndexPath) -> String {
        switch item {
        case .title:
            return titleConfigurator?.reuseIdentifier ?? ""
        case .textField:
            return textFieldConfigurator?.reuseIdentifier ?? ""
        }
    }

    func configuredCell(for item: ChangePassword.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {

        case .title(let text):
            return titleConfigurator?.configuredCell(for: text, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .textField(let model):
            return textFieldConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        }
    }

    func registerCells(in tableView: UITableView) {
        titleConfigurator?.registerCells(in: tableView)
        textFieldConfigurator?.registerCells(in: tableView)
    }


}

extension ChangePasswordPresenter {

    var dataSourceConfigurator: ChangePasswordCellsConfigutator {
        get {
            var configurator = ChangePasswordCellsConfigutator()

            // sectionTitleConfigurator
            configurator.titleConfigurator = CellConfigurator { (cell, model: String, tableView, indexPath) -> SectionTitleTableViewCell in
                cell.titleLabel.text = model
                return cell
            }

            // textFieldConfigurator
            configurator.textFieldConfigurator = CellConfigurator { (cell, model: TextFieldModel, tableView, indexPath) -> TextFieldTableViewCell in
                cell.delegate = self
                cell.textField.text = model.text
                cell.textField.isSecureTextEntry = true
                cell.textKeyPath = model.associatedKeyPath
                cell.textField.placeholder = model.placeholder
                cell.textField.keyboardType = model.keyboardType
                return cell
            }

            return configurator
        }
    }


}
