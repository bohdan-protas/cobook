//
//  CreateBusinessCardConfigurator.swift
//  CoBook
//
//  Created by protas on 3/31/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct CreateBusinessCardDataSourceConfigurator: TableCellConfiguratorType {

    var sectionTitleConfigurator: TableCellConfigurator<String, SectionTitleTableViewCell>?
    var sectionHeaderConfigurator: TableCellConfigurator<Void?, SectionHeaderTableViewCell>?
    var textFieldConfigurator: TableCellConfigurator<TextFieldModel, TextFieldTableViewCell>?
    var actionFieldConfigurator: TableCellConfigurator<ActionFieldModel, TextFieldTableViewCell>?
    var textViewConfigurator: TableCellConfigurator<TextFieldModel, TextViewTableViewCell>?
    var socialListConfigurator: TableCellConfigurator<Void?, SocialsListTableViewCell>?
    var interestsListConfigurator: TableCellConfigurator<Void?, TagsListTableViewCell>?
    var avatarManagmentConfigurator: TableCellConfigurator<CardAvatarManagmentCellModel, CardAvatarPhotoManagmentTableViewCell>?
    var backgroundImageManagmentConfigurator: TableCellConfigurator<BackgroundManagmentImageCellModel, CardBackgroundManagmentTableViewCell>?
    var employersSearchCellConfigurator: TableCellConfigurator<Void?, SearchTableViewCell>?
    var employersListCellConfigurator: TableCellConfigurator<Void?, EmployersPreviewHorizontalListTableViewCell>?

    // MARK: - CellConfiguratorType

    func reuseIdentifier(for item: CreateBusinessCard.Cell, indexPath: IndexPath) -> String {
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
        case .backgroundImageManagment:
            return backgroundImageManagmentConfigurator?.reuseIdentifier ?? ""
        case .employersSearch:
            return employersSearchCellConfigurator?.reuseIdentifier ?? ""
        case .employersList:
            return employersListCellConfigurator?.reuseIdentifier ?? ""
        }
    }

    func configuredCell(for item: CreateBusinessCard.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
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
        case .backgroundImageManagment(let model):
            return backgroundImageManagmentConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .employersSearch:
            return employersSearchCellConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .employersList:
            return employersListCellConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
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
        backgroundImageManagmentConfigurator?.registerCells(in: tableView)
        employersSearchCellConfigurator?.registerCells(in: tableView)
        employersListCellConfigurator?.registerCells(in: tableView)
    }


}

extension CreateBusinessCardPresenter {

    var dataSourceConfigurator: CreateBusinessCardDataSourceConfigurator {
        get {

            var viewDataSourceConfigurator = CreateBusinessCardDataSourceConfigurator()

            // sectionTitleConfigurator
            viewDataSourceConfigurator.sectionTitleConfigurator = TableCellConfigurator { (cell, model: String, tableView, indexPath) -> SectionTitleTableViewCell in
                cell.titleLabel.text = model
                return cell
            }

            // sectionHeaderConfigurator
            viewDataSourceConfigurator.sectionHeaderConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> SectionHeaderTableViewCell in
                return cell
            }

            // textFieldConfigurator
            viewDataSourceConfigurator.textFieldConfigurator = TableCellConfigurator { (cell, model: TextFieldModel, tableView, indexPath) -> TextFieldTableViewCell in
                cell.delegate = self
                cell.textField.text = model.text
                cell.textKeyPath = model.associatedKeyPath
                cell.textField.placeholder = model.placeholder
                cell.textField.keyboardType = model.keyboardType
                return cell
            }

            // textViewConfigurator
            viewDataSourceConfigurator.textViewConfigurator = TableCellConfigurator { (cell, model: TextFieldModel, tableView, indexPath) -> TextViewTableViewCell in
                cell.delegate = self
                cell.textView.text = model.text
                cell.textView.placeholder = model.placeholder
                cell.textKeyPath = model.associatedKeyPath
                return cell
            }

            // actionFieldConfigurator
            viewDataSourceConfigurator.actionFieldConfigurator = TableCellConfigurator { (cell, model: ActionFieldModel, tableView, indexPath) -> TextFieldTableViewCell in
                cell.delegate = self
                cell.dataSource = self
                cell.textField.text = model.text
                cell.textField.placeholder = model.placeholder
                cell.actionIdentifier = model.actionTypeId

                if let action = CreateBusinessCard.ActionType(rawValue: model.actionTypeId ?? "") {
                    switch action {
                    case .practice:
                        cell.textField.inputView = cell.pickerView
                    default:
                        cell.actionControlView.isUserInteractionEnabled = true
                        cell.textField.isUserInteractionEnabled = false
                    }
                }
                return cell
            }

            // socialListConfigurator
            viewDataSourceConfigurator.socialListConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> SocialsListTableViewCell in
                cell.delegate = self
                cell.dataSource = self
                cell.isEditable = true
                return cell
            }

            // interestsListConfigurator
            viewDataSourceConfigurator.interestsListConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> TagsListTableViewCell in
                cell.dataSource = self
                cell.delegate = self
                return cell
            }

            // avatarManagmentConfigurator
            viewDataSourceConfigurator.avatarManagmentConfigurator = TableCellConfigurator { (cell, model: CardAvatarManagmentCellModel, tableView, indexPath) -> CardAvatarPhotoManagmentTableViewCell in
                cell.delegate = self.view
                cell.set(sourceType: .businessCard)
                if let imageData = model.imageData, let image = UIImage(data: imageData) {
                    cell.set(image: image)
                } else {
                    cell.set(imagePath: model.imagePath)
                }

                return cell
            }

            // backgroundImageManagmentConfigurator
            viewDataSourceConfigurator.backgroundImageManagmentConfigurator = TableCellConfigurator { (cell, model: BackgroundManagmentImageCellModel, tableView, indexPath) -> CardBackgroundManagmentTableViewCell in
                cell.delegate = self.view
                if let imageData = model.imageData, let image = UIImage(data: imageData) {
                    cell.set(image: image)
                } else {
                    cell.set(imagePath: model.imagePath)
                }
                return cell
            }

            // employersSearchCellConfigurator
            viewDataSourceConfigurator.employersSearchCellConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> SearchTableViewCell in
                cell.delegate = self
                return cell
            }

            // employersListCellConfigurator
            viewDataSourceConfigurator.employersListCellConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> EmployersPreviewHorizontalListTableViewCell in
                cell.dataSource = self
                cell.delegate = self
                cell.collectionView.reloadData()
                return cell
            }

            return viewDataSourceConfigurator
        }
    }
}


