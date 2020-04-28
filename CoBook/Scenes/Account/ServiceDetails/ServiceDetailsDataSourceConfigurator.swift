//
//  ServiceDetailsDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct ServiceDetailsDataSourceConfigurator: CellConfiguratorType {

    var galleryConfigurator: CellConfigurator<Void?, HorizontalPhotosListTableViewCell>?
    var sectionSeparatorConfigurator: CellConfigurator<Void?, SectionHeaderTableViewCell>?
    var companyHeaderConfigurator: CellConfigurator<CompanyPreviewHeaderModel, CompanyPreviewHeaderTableViewCell>?
    var getInTouchCellConfigurator: CellConfigurator<Void?, GetInTouchTableViewCell>?

    func reuseIdentifier(for item: Service.DetailsCell, indexPath: IndexPath) -> String {
        switch item {
        case .gallery:
            return galleryConfigurator?.reuseIdentifier ?? ""
        case .sectionSeparator:
            return sectionSeparatorConfigurator?.reuseIdentifier ?? ""
        case .companyHeader:
            return companyHeaderConfigurator?.reuseIdentifier ?? ""
        case .getInTouch:
            return self.getInTouchCellConfigurator?.reuseIdentifier ?? ""
        }
    }

    func configuredCell(for item: Service.DetailsCell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .gallery:
            return galleryConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .sectionSeparator:
            return sectionSeparatorConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .companyHeader(let model):
            return companyHeaderConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .getInTouch:
            return getInTouchCellConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        }
    }

    func registerCells(in tableView: UITableView) {
        galleryConfigurator?.registerCells(in: tableView)
        sectionSeparatorConfigurator?.registerCells(in: tableView)
        companyHeaderConfigurator?.registerCells(in: tableView)
        getInTouchCellConfigurator?.registerCells(in: tableView)
    }


}

// MARK: - ServiceDetailsPresenter data source configuration

extension ServiceDetailsPresenter {

    /// Dependency injection to BusinessCardDetailsPresenter
    var dataSouceConfigurator: ServiceDetailsDataSourceConfigurator {
        get {

            var configurator = ServiceDetailsDataSourceConfigurator()

            // galleryConfigurator
            configurator.galleryConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> HorizontalPhotosListTableViewCell in
                cell.dataSource = self
                cell.isEditable = false
                return cell
            }

            // sectionHeaderConfigurator
            configurator.sectionSeparatorConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> SectionHeaderTableViewCell in
                return cell
            }

            // companyHeaderConfigurator
            configurator.companyHeaderConfigurator = CellConfigurator { (cell, model: CompanyPreviewHeaderModel, tableView, indexPath) -> CompanyPreviewHeaderTableViewCell in
                cell.avatarImageView.setImage(withPath: model.image)
                cell.nameLabel.text = model.title
                return cell
            }

            // getInTouchCellConfigurator
            configurator.getInTouchCellConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> GetInTouchTableViewCell in
                cell.delegate = self
                return cell
            }

            return configurator
        }
    }


}
