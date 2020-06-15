//
//  CreateProductDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/28/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct CreateProductDataSourceConfigurator: TableCellConfiguratorType {

    var galleryConfigurator: TableCellConfigurator<Void?, HorizontalPhotosListTableViewCell>?
    var sectionSeparatorConfigurator: TableCellConfigurator<Void?, SectionHeaderTableViewCell>?
    var sectionTitleConfigurator: TableCellConfigurator<String, SectionTitleTableViewCell>?
    var textFieldConfigurator: TableCellConfigurator<TextFieldModel, TextFieldTableViewCell>?
    var textViewConfigurator: TableCellConfigurator<TextFieldModel, TextViewTableViewCell>?
    var checkboxConfigurator: TableCellConfigurator<CheckboxModel, CheckboxTableViewCell>?
    var companyHeaderConfigurator: TableCellConfigurator<CompanyPreviewHeaderModel, CompanyPreviewHeaderTableViewCell>?
    var actionFieldConfigurator: TableCellConfigurator<ActionFieldModel, TextFieldTableViewCell>?

    func reuseIdentifier(for item: CreateProduct.Cell, indexPath: IndexPath) -> String {
        switch item {
        case .gallery:
            return galleryConfigurator?.reuseIdentifier ?? ""
        case .sectionSeparator:
            return sectionSeparatorConfigurator?.reuseIdentifier ?? ""
        case .title:
            return sectionTitleConfigurator?.reuseIdentifier ?? ""
        case .textField:
            return textFieldConfigurator?.reuseIdentifier ?? ""
        case .textView:
            return textViewConfigurator?.reuseIdentifier ?? ""
        case .checkbox:
            return checkboxConfigurator?.reuseIdentifier ?? ""
        case .companyHeader:
            return companyHeaderConfigurator?.reuseIdentifier ?? ""
        case .actionField:
            return actionFieldConfigurator?.reuseIdentifier ?? ""
        }
    }

    func configuredCell(for item: CreateProduct.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .gallery:
            return galleryConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .sectionSeparator:
            return sectionSeparatorConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .title(let text):
            return sectionTitleConfigurator?.configuredCell(for: text, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .textField(let model):
            return textFieldConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .textView(let model):
            return textViewConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .checkbox(let model):
            return checkboxConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .companyHeader(let model):
            return companyHeaderConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .actionField(let model):
            return actionFieldConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        }
    }

    func registerCells(in tableView: UITableView) {
        galleryConfigurator?.registerCells(in: tableView)
        sectionSeparatorConfigurator?.registerCells(in: tableView)
        sectionTitleConfigurator?.registerCells(in: tableView)
        textFieldConfigurator?.registerCells(in: tableView)
        textViewConfigurator?.registerCells(in: tableView)
        checkboxConfigurator?.registerCells(in: tableView)
        companyHeaderConfigurator?.registerCells(in: tableView)
        actionFieldConfigurator?.registerCells(in: tableView)
    }


}

// MARK: - CreateServicePresenter data source configuration

extension CreateProductPresenter {

    /// Dependency injection to BusinessCardDetailsPresenter
    var dataSouceConfigurator: CreateProductDataSourceConfigurator {
        get {

            var configurator = CreateProductDataSourceConfigurator()

            // galleryConfigurator
            configurator.galleryConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> HorizontalPhotosListTableViewCell in
                cell.dataSource = self
                cell.delegate = self.view
                cell.isEditable = true
                return cell
            }

            // sectionTitleConfigurator
            configurator.sectionTitleConfigurator = TableCellConfigurator { (cell, model: String, tableView, indexPath) -> SectionTitleTableViewCell in
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
                cell.textField.isEnabled = model.isEnabled
                cell.textField.alpha = model.isEnabled ? 1 : 0.5
                cell.textField.text = model.text
                cell.textKeyPath = model.associatedKeyPath
                cell.textField.placeholder = model.placeholder
                cell.textField.keyboardType = model.keyboardType
                return cell
            }

            // textViewConfigurator
            configurator.textViewConfigurator = TableCellConfigurator { (cell, model: TextFieldModel, tableView, indexPath) -> TextViewTableViewCell in
                cell.delegate = self
                cell.textView.text = model.text
                cell.textView.placeholder = model.placeholder
                cell.textKeyPath = model.associatedKeyPath
                return cell
            }

            // checkboxConfigurator
            configurator.checkboxConfigurator = TableCellConfigurator { (cell, model: CheckboxModel, tableView, indexPath) -> CheckboxTableViewCell in
                cell.checkboxButton.setTitle(model.title, for: .normal)
                cell.checkboxButton.setTitle(model.title, for: .selected)
                cell.checkboxButton.isSelected = model.isSelected
                cell.checkboxActionHandler = model.handler
                return cell
            }

            // companyHeaderConfigurator
            configurator.companyHeaderConfigurator = TableCellConfigurator { (cell, model: CompanyPreviewHeaderModel, tableView, indexPath) -> CompanyPreviewHeaderTableViewCell in
                cell.avatarImageView.setImage(withPath: model.image)
                cell.nameLabel.text = model.title
                return cell
            }

            // actionFieldConfigurator
            configurator.actionFieldConfigurator = TableCellConfigurator { (cell, model: ActionFieldModel, tableView, indexPath) -> TextFieldTableViewCell in
                cell.delegate = self
                cell.dataSource = self
                cell.textField.text = model.text
                cell.textField.placeholder = model.placeholder
                cell.actionIdentifier = model.actionTypeId

                if let action = CreateProduct.ActionType(rawValue: model.actionTypeId ?? "") {
                    switch action {
                    case .showroomNumber:
                        cell.textField.inputView = cell.pickerView
                    }
                }
                return cell
            }

            return configurator
        }
    }


}
