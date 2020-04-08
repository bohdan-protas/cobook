//
//  BusinessCardDetailsDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct CardItemViewModel {
    var id: String?
    var avatarPath: String?
    var name: String?
    var profession: String?
    var telephoneNumber: String?
}

struct BusinessCardDetailsDataSourceConfigurator: CellConfiguratorType {

    // MARK: - Properties

    weak var presenter: BusinessCardDetailsPresenter?

    var headerInfoCellConfigurator: CellConfigurator<BusinessCardDetails.HeaderInfoModel?, BusinessCardHeaderInfoTableViewCell>
    var sectionTitleConfigurator: CellConfigurator<String, SectionTitleTableViewCell>
    var sectionHeaderConfigurator: CellConfigurator<Void?, SectionHeaderTableViewCell>
    var getInTouchCellConfigurator: CellConfigurator<Void?, GetInTouchTableViewCell>
    var socialListConfigurator: CellConfigurator<Void?, SocialsListTableViewCell>
    var expandableDescriptionCellConfigurator: CellConfigurator<String?, ExpandableDescriptionTableViewCell>
    var mapDirectionCellConfigurator: CellConfigurator<Void?, MapDirectionTableViewCell>
    var mapCellConfigurator: CellConfigurator<String?, MapTableViewCell>
    var addressInfoCellConfigurator: CellConfigurator<AddressInfoCellModel, AddressInfoTableViewCell>
    var employeeCellConfigurator: CellConfigurator<CardItemViewModel?, PersonalCardItemTableViewCell>

    // MARK: - Initializer

    init(presenter: BusinessCardDetailsPresenter) {
        self.presenter = presenter

        employeeCellConfigurator = CellConfigurator { (cell, model: CardItemViewModel?, tableView, indexPath) -> PersonalCardItemTableViewCell in
            cell.userAvatarImageView.setImage(withPath: model?.avatarPath)
            cell.nameLabel.text = model?.name
            cell.professionLabel.text = model?.profession
            cell.telNumberLabel.text = model?.telephoneNumber

            return cell
        }

        headerInfoCellConfigurator = CellConfigurator { (cell, model: BusinessCardDetails.HeaderInfoModel?, tableView, indexPath) -> BusinessCardHeaderInfoTableViewCell in
            cell.bgImageView.setImage(withPath: model?.bgimagePath)
            cell.avatarImageView.setImage(withPath: model?.avatartImagePath)
            cell.nameLabel.text = model?.name
            cell.professionLabel.text = model?.profession
            cell.telephoneNumberLabel.text = model?.telephoneNumber
            cell.websiteLabel.text = model?.websiteAddress

            return cell
        }

        sectionTitleConfigurator = CellConfigurator { (cell, model: String, tableView, indexPath) -> SectionTitleTableViewCell in
            cell.titleLabel.text = model
            return cell
        }

        sectionHeaderConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> SectionHeaderTableViewCell in
            return cell
        }

        getInTouchCellConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> GetInTouchTableViewCell in
            cell.delegate = presenter
            return cell
        }

        socialListConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> SocialsListTableViewCell in
            cell.delegate = presenter
            cell.dataSource = presenter
            cell.isEditable = false
            return cell
        }

        expandableDescriptionCellConfigurator = CellConfigurator { (cell, model: String?, tableView, indexPath) -> ExpandableDescriptionTableViewCell in
            cell.textDescriptionLabel.text = model
            return cell
        }

        mapDirectionCellConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> MapDirectionTableViewCell in
            return cell
        }

        mapCellConfigurator = CellConfigurator { (cell, model: String?, tableView, indexPath) -> MapTableViewCell in
            let mapURL = cell.constructStaticMapURL(mapSize: cell.mapImageView.frame.size)
            cell.mapImageView.setImage(withURL: mapURL)
            return cell
        }

        addressInfoCellConfigurator = CellConfigurator { (cell, model: AddressInfoCellModel, tableView, indexPath) -> AddressInfoTableViewCell in
            cell.mainAddressLabel.text = model.mainAddress
            cell.subadressLabel.text = model.subAdress
            cell.scheduleLabel.text = model.schedule
            return cell
        }
    }

    // MARK: - Cell configurator

    func reuseIdentifier(for item: BusinessCardDetails.Cell, indexPath: IndexPath) -> String {
        switch item {
        case .sectionHeader:
            return sectionHeaderConfigurator.reuseIdentifier
        case .userInfo:
            return self.headerInfoCellConfigurator.reuseIdentifier
        case .getInTouch:
            return self.getInTouchCellConfigurator.reuseIdentifier
        case .socialList:
            return socialListConfigurator.reuseIdentifier
        case .addressInfo:
            return addressInfoCellConfigurator.reuseIdentifier
        case .map:
            return mapCellConfigurator.reuseIdentifier
        case .mapDirection:
            return mapDirectionCellConfigurator.reuseIdentifier
        case .companyDescription:
            return expandableDescriptionCellConfigurator.reuseIdentifier
        case .title:
            return sectionTitleConfigurator.reuseIdentifier
        case .employee:
            return employeeCellConfigurator.reuseIdentifier
        }
    }

    func configuredCell(for item: BusinessCardDetails.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .sectionHeader:
            return sectionHeaderConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
        case .userInfo(let model):
            return headerInfoCellConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .getInTouch:
            return getInTouchCellConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
        case .socialList:
            return socialListConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
        case .addressInfo(let model):
            return addressInfoCellConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .map(let path):
            return mapCellConfigurator.configuredCell(for: path, tableView: tableView, indexPath: indexPath)
        case .mapDirection:
            return mapDirectionCellConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
        case .companyDescription(let text):
            return expandableDescriptionCellConfigurator.configuredCell(for: text, tableView: tableView, indexPath: indexPath)
        case .title(let text):
            return sectionTitleConfigurator.configuredCell(for: text, tableView: tableView, indexPath: indexPath)
        case .employee(let model):
            return employeeCellConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        }
    }

    func registerCells(in tableView: UITableView) {
        headerInfoCellConfigurator.registerCells(in: tableView)
        sectionTitleConfigurator.registerCells(in: tableView)
        sectionHeaderConfigurator.registerCells(in: tableView)
        getInTouchCellConfigurator.registerCells(in: tableView)
        socialListConfigurator.registerCells(in: tableView)
        expandableDescriptionCellConfigurator.registerCells(in: tableView)
        mapDirectionCellConfigurator.registerCells(in: tableView)
        mapCellConfigurator.registerCells(in: tableView)
        addressInfoCellConfigurator.registerCells(in: tableView)
        employeeCellConfigurator.registerCells(in: tableView)
    }
}
