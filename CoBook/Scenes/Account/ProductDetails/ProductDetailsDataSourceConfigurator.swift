//
//  ProductDetailsDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/29/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


struct ProductDetailsDataSourceConfigurator: TableCellConfiguratorType {

    var galleryConfigurator: TableCellConfigurator<Void?, HorizontalPhotosListTableViewCell>?
    var sectionSeparatorConfigurator: TableCellConfigurator<Void?, SectionHeaderTableViewCell>?
    var companyHeaderConfigurator: TableCellConfigurator<CompanyPreviewHeaderModel, CompanyPreviewHeaderTableViewCell>?
    var getInTouchCellConfigurator: TableCellConfigurator<Void?, GetInTouchTableViewCell>?
    var descriptionConfigurator: TableCellConfigurator<TitleDescrModel?, ExpandableDescriptionTableViewCell>?
    var titleHeaderConfigurator: TableCellConfigurator<TitleDescrModel?, ExpandableDescriptionTableViewCell>?

    func reuseIdentifier(for item:  ProductDetails.Cell, indexPath: IndexPath) -> String {
        switch item {
        case .gallery:
            return galleryConfigurator?.reuseIdentifier ?? ""
        case .sectionSeparator:
            return sectionSeparatorConfigurator?.reuseIdentifier ?? ""
        case .companyHeader:
            return companyHeaderConfigurator?.reuseIdentifier ?? ""
        case .getInTouch:
            return self.getInTouchCellConfigurator?.reuseIdentifier ?? ""
        case .serviceDescription:
            return self.descriptionConfigurator?.reuseIdentifier ?? ""
        case .serviceHeaderDescr:
            return self.titleHeaderConfigurator?.reuseIdentifier ?? ""
        }
    }

    func configuredCell(for item: ProductDetails.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .gallery:
            return galleryConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .sectionSeparator:
            return sectionSeparatorConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .companyHeader(let model):
            return companyHeaderConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .getInTouch:
            return getInTouchCellConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .serviceHeaderDescr(let model):
            return titleHeaderConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .serviceDescription(let model):
            return descriptionConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        }
    }

    func registerCells(in tableView: UITableView) {
        galleryConfigurator?.registerCells(in: tableView)
        sectionSeparatorConfigurator?.registerCells(in: tableView)
        companyHeaderConfigurator?.registerCells(in: tableView)
        getInTouchCellConfigurator?.registerCells(in: tableView)
        descriptionConfigurator?.registerCells(in: tableView)
        titleHeaderConfigurator?.registerCells(in: tableView)
    }


}

// MARK: - ServiceDetailsPresenter data source configuration

extension ProductDetailsPresenter {

    /// Dependency injection to BusinessCardDetailsPresenter
    var dataSouceConfigurator: ProductDetailsDataSourceConfigurator {
        get {

            var configurator = ProductDetailsDataSourceConfigurator()

            // galleryConfigurator
            configurator.galleryConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> HorizontalPhotosListTableViewCell in
                cell.dataSource = self
                cell.isEditable = false
                return cell
            }

            // sectionHeaderConfigurator
            configurator.sectionSeparatorConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> SectionHeaderTableViewCell in
                return cell
            }

            // companyHeaderConfigurator
            configurator.companyHeaderConfigurator = TableCellConfigurator { (cell, model: CompanyPreviewHeaderModel, tableView, indexPath) -> CompanyPreviewHeaderTableViewCell in
                cell.avatarImageView.setImage(withPath: model.image)
                cell.nameLabel.text = model.title
                return cell
            }

            // getInTouchCellConfigurator
            configurator.getInTouchCellConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> GetInTouchTableViewCell in
                cell.delegate = self
                return cell
            }

            // expandableDescriptionCellConfigurator
            configurator.descriptionConfigurator = TableCellConfigurator { (cell, model: TitleDescrModel?, tableView, indexPath) -> ExpandableDescriptionTableViewCell in
                cell.titleLabel.text = model?.title
                cell.desctiptionTextView.text = model?.descr
                return cell
            }

            // expandableDescriptionCellConfigurator
            configurator.titleHeaderConfigurator = TableCellConfigurator { (cell, model: TitleDescrModel?, tableView, indexPath) -> ExpandableDescriptionTableViewCell in
                cell.titleLabel.attributedText = NSAttributedString(string: model?.title ?? "", attributes: [.foregroundColor: UIColor.Theme.blackMiddle, .font: UIFont.SFProDisplay_Medium(size: 20)])
                cell.desctiptionTextView.attributedText = NSAttributedString(string: model?.descr ?? "", attributes: [.foregroundColor: UIColor.Theme.greenDark, .font: UIFont.SFProDisplay_Regular(size: 14)])
                cell.desctiptionTextView.isUserInteractionEnabled = false
                return cell
            }

            return configurator
        }
    }


}
