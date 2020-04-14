//
//  CreatePersonalCardDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/3/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct CreatePersonalCardDataSourceConfigurator: CellConfiguratorType {

    // MARK: Properties
    weak var presenter: CreatePersonalCardPresenter?

    let sectionTitleConfigurator: CellConfigurator<String, SectionTitleTableViewCell>
    let sectionHeaderConfigurator: CellConfigurator<Void?, SectionHeaderTableViewCell>
    let textFieldConfigurator: CellConfigurator<TextFieldModel, TextFieldTableViewCell>
    let actionFieldConfigurator: CellConfigurator<ActionFieldModel, TextFieldTableViewCell>
    let textViewConfigurator: CellConfigurator<TextFieldModel, TextViewTableViewCell>
    let socialListConfigurator: CellConfigurator<Void?, SocialsListTableViewCell>
    let interestsListConfigurator: CellConfigurator<Void?, InterestsSelectionTableViewCell>
    let avatarManagmentConfigurator: CellConfigurator<CardAvatarManagmentCellModel, CardAvatarPhotoManagmentTableViewCell>

    // MARK: Initializer
    init(presenter: CreatePersonalCardPresenter) {
        self.presenter = presenter

        // MARK: Cell configurators
        sectionTitleConfigurator = CellConfigurator { (cell, model: String, tableView, indexPath) -> SectionTitleTableViewCell in
            cell.titleLabel.text = model
            return cell
        }

        sectionHeaderConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> SectionHeaderTableViewCell in
            return cell
        }

        textFieldConfigurator = CellConfigurator { (cell, model: TextFieldModel, tableView, indexPath) -> TextFieldTableViewCell in
            cell.delegate = presenter
            cell.textField.text = model.text
            cell.textKeyPath = model.associatedKeyPath
            cell.textField.placeholder = model.placeholder
            cell.textField.keyboardType = model.keyboardType
            return cell
        }

        textViewConfigurator = CellConfigurator { (cell, model: TextFieldModel, tableView, indexPath) -> TextViewTableViewCell in
            cell.delegate = presenter
            cell.textKeyPath = model.associatedKeyPath
            cell.textView.text = model.text
            cell.textView.placeholder = model.placeholder
            return cell
        }

        actionFieldConfigurator = CellConfigurator { (cell, model: ActionFieldModel, tableView, indexPath) -> TextFieldTableViewCell in
            cell.delegate = presenter
            cell.dataSource = presenter
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

        socialListConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> SocialsListTableViewCell in
            cell.delegate = presenter
            cell.dataSource = presenter
            cell.isEditable = true
            return cell
        }

        interestsListConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> InterestsSelectionTableViewCell in
            cell.dataSource = presenter
            return cell
        }

        avatarManagmentConfigurator = CellConfigurator { (cell, model: CardAvatarManagmentCellModel, tableView, indexPath) -> CardAvatarPhotoManagmentTableViewCell in
            cell.delegate = presenter
            cell.set(sourceType: model.sourceType)
            cell.set(imagePath: model.imagePath)
            return cell
        }
    }

    func reuseIdentifier(for item: CreatePersonalCard.Cell, indexPath: IndexPath) -> String {
        switch item {
        case .textField, .actionField:
            return textFieldConfigurator.reuseIdentifier
        case .textView:
            return textViewConfigurator.reuseIdentifier
        case .title:
            return sectionTitleConfigurator.reuseIdentifier
        case .sectionHeader:
            return sectionHeaderConfigurator.reuseIdentifier
        case .socials:
            return socialListConfigurator.reuseIdentifier
        case .interests:
            return interestsListConfigurator.reuseIdentifier
        case .avatarManagment:
            return avatarManagmentConfigurator.reuseIdentifier
        }
    }

    func configuredCell(for item: CreatePersonalCard.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .textField(let model):
            return textFieldConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .textView(let model):
            return textViewConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .actionField(let model):
            return actionFieldConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .title(let model):
            return sectionTitleConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .sectionHeader:
            return sectionHeaderConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
        case .socials:
            return socialListConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
        case .interests:
            return interestsListConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
        case .avatarManagment(let model):
            return avatarManagmentConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        }
    }

    func registerCells(in tableView: UITableView) {
        sectionTitleConfigurator.registerCells(in: tableView)
        sectionHeaderConfigurator.registerCells(in: tableView)
        textFieldConfigurator.registerCells(in: tableView)
        actionFieldConfigurator.registerCells(in: tableView)
        textViewConfigurator.registerCells(in: tableView)
        socialListConfigurator.registerCells(in: tableView)
        interestsListConfigurator.registerCells(in: tableView)
        avatarManagmentConfigurator.registerCells(in: tableView)
    }
}
