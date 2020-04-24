//
//  CreatePersonalCardDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/3/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct CreatePersonalCardDataSourceConfigurator: CellConfiguratorType {

    var sectionTitleConfigurator: CellConfigurator<String, SectionTitleTableViewCell>?
    var sectionHeaderConfigurator: CellConfigurator<Void?, SectionHeaderTableViewCell>?
    var textFieldConfigurator: CellConfigurator<TextFieldModel, TextFieldTableViewCell>?
    var actionFieldConfigurator: CellConfigurator<ActionFieldModel, TextFieldTableViewCell>?
    var textViewConfigurator: CellConfigurator<TextFieldModel, TextViewTableViewCell>?
    var socialListConfigurator: CellConfigurator<Void?, SocialsListTableViewCell>?
    var interestsListConfigurator: CellConfigurator<Void?, InterestsSelectionTableViewCell>?
    var avatarManagmentConfigurator: CellConfigurator<CardAvatarManagmentCellModel, CardAvatarPhotoManagmentTableViewCell>?

    func reuseIdentifier(for item: CreatePersonalCard.Cell, indexPath: IndexPath) -> String {
        switch item {
        case .textField, .actionField:
            return textFieldConfigurator?.reuseIdentifier ?? ""
        case .textView:
            return textViewConfigurator?.reuseIdentifier ?? ""
        case .title:
            return sectionTitleConfigurator?.reuseIdentifier ?? ""
        case .sectionHeader:
            return sectionHeaderConfigurator?.reuseIdentifier ?? ""
        case .socials:
            return socialListConfigurator?.reuseIdentifier ?? ""
        case .interests:
            return interestsListConfigurator?.reuseIdentifier ?? ""
        case .avatarManagment:
            return avatarManagmentConfigurator?.reuseIdentifier ?? ""
        }
    }

    func configuredCell(for item: CreatePersonalCard.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .textField(let model):
            return textFieldConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .textView(let model):
            return textViewConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .actionField(let model):
            return actionFieldConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .title(let model):
            return sectionTitleConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .sectionHeader:
            return sectionHeaderConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .socials:
            return socialListConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .interests:
            return interestsListConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .avatarManagment(let model):
            return avatarManagmentConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        }
    }

    func registerCells(in tableView: UITableView) {
        sectionTitleConfigurator?.registerCells(in: tableView)
        sectionHeaderConfigurator?.registerCells(in: tableView)
        textFieldConfigurator?.registerCells(in: tableView)
        actionFieldConfigurator?.registerCells(in: tableView)
        textViewConfigurator?.registerCells(in: tableView)
        socialListConfigurator?.registerCells(in: tableView)
        interestsListConfigurator?.registerCells(in: tableView)
        avatarManagmentConfigurator?.registerCells(in: tableView)
    }
}

extension CreatePersonalCardPresenter {

    var dataSourceConfigurator: CreatePersonalCardDataSourceConfigurator {
        get {

            var viewDataSourceConfigurator = CreatePersonalCardDataSourceConfigurator()

            // sectionTitleConfigurator
            viewDataSourceConfigurator.sectionTitleConfigurator = CellConfigurator { (cell, model: String, tableView, indexPath) -> SectionTitleTableViewCell in
                cell.titleLabel.text = model
                return cell
            }

            // sectionHeaderConfigurator
            viewDataSourceConfigurator.sectionHeaderConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> SectionHeaderTableViewCell in
                return cell
            }

            // textFieldConfigurator
            viewDataSourceConfigurator.textFieldConfigurator = CellConfigurator { (cell, model: TextFieldModel, tableView, indexPath) -> TextFieldTableViewCell in
                cell.delegate = self
                cell.textField.text = model.text
                cell.textKeyPath = model.associatedKeyPath
                cell.textField.placeholder = model.placeholder
                cell.textField.keyboardType = model.keyboardType
                return cell
            }

            // textViewConfigurator
            viewDataSourceConfigurator.textViewConfigurator = CellConfigurator { (cell, model: TextFieldModel, tableView, indexPath) -> TextViewTableViewCell in
                cell.delegate = self
                cell.textView.text = model.text
                cell.textView.placeholder = model.placeholder
                cell.textKeyPath = model.associatedKeyPath
                return cell
            }

            // actionFieldConfigurator
            viewDataSourceConfigurator.actionFieldConfigurator = CellConfigurator { (cell, model: ActionFieldModel, tableView, indexPath) -> TextFieldTableViewCell in
                cell.delegate = self
                cell.dataSource = self
                cell.textField.text = model.text
                cell.textField.placeholder = model.placeholder
                cell.actionIdentifier = model.actionTypeId

                if let action = CreatePersonalCard.ActionType(rawValue: model.actionTypeId ?? "") {
                    switch action {
                    case .activityType:
                        cell.textField.inputView = cell.pickerView
                    default:
                        cell.actionControlView.isUserInteractionEnabled = true
                        cell.textField.isUserInteractionEnabled = false
                    }
                }
                return cell
            }

            // socialListConfigurator
            viewDataSourceConfigurator.socialListConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> SocialsListTableViewCell in
                cell.delegate = self
                cell.dataSource = self
                cell.isEditable = true
                return cell
            }

            // interestsListConfigurator
            viewDataSourceConfigurator.interestsListConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> InterestsSelectionTableViewCell in
                cell.dataSource = self
                return cell
            }

            // avatarManagmentConfigurator
            viewDataSourceConfigurator.avatarManagmentConfigurator = CellConfigurator { (cell, model: CardAvatarManagmentCellModel, tableView, indexPath) -> CardAvatarPhotoManagmentTableViewCell in
                cell.delegate = self.view
                cell.set(sourceType: .personalCard)
                if let imageData = model.imageData, let image = UIImage(data: imageData) {
                    cell.set(image: image)
                } else {
                    cell.set(imagePath: model.imagePath)
                }

                return cell
            }

            return viewDataSourceConfigurator
        }
    }


}
