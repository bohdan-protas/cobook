//
//  BusinessCardDetailsDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


struct BusinessCardDetailsDataSourceConfigurator: CellConfiguratorType {

    var headerInfoCellConfigurator: CellConfigurator<BusinessCardDetails.HeaderInfoModel?, BusinessCardHeaderInfoTableViewCell>?
    var sectionTitleConfigurator: CellConfigurator<String, SectionTitleTableViewCell>?
    var sectionHeaderConfigurator: CellConfigurator<Void?, SectionHeaderTableViewCell>?
    var getInTouchCellConfigurator: CellConfigurator<Void?, GetInTouchTableViewCell>?
    var socialListConfigurator: CellConfigurator<Void?, SocialsListTableViewCell>?
    var expandableDescriptionCellConfigurator: CellConfigurator<String?, ExpandableDescriptionTableViewCell>?
    var mapDirectionCellConfigurator: CellConfigurator<Void?, MapDirectionTableViewCell>?
    var mapCellConfigurator: CellConfigurator<String?, MapTableViewCell>?
    var addressInfoCellConfigurator: CellConfigurator<AddressInfoCellModel, AddressInfoTableViewCell>?
    var employeeCellConfigurator: CellConfigurator<EmployeeModel?, CardItemTableViewCell>?
    var contactsCellConfigurator: CellConfigurator<ContactsModel?, ContactsTableViewCell>?

    // MARK: - Cell configurator

    func reuseIdentifier(for item: BusinessCardDetails.Cell, indexPath: IndexPath) -> String {
        switch item {
        case .sectionHeader:
            return sectionHeaderConfigurator?.reuseIdentifier ?? ""
        case .userInfo:
            return self.headerInfoCellConfigurator?.reuseIdentifier ?? ""
        case .getInTouch:
            return self.getInTouchCellConfigurator?.reuseIdentifier ?? ""
        case .socialList:
            return socialListConfigurator?.reuseIdentifier ?? ""
        case .addressInfo:
            return addressInfoCellConfigurator?.reuseIdentifier ?? ""
        case .map:
            return mapCellConfigurator?.reuseIdentifier ?? ""
        case .mapDirection:
            return mapDirectionCellConfigurator?.reuseIdentifier ?? ""
        case .companyDescription:
            return expandableDescriptionCellConfigurator?.reuseIdentifier ?? ""
        case .title:
            return sectionTitleConfigurator?.reuseIdentifier ?? ""
        case .employee:
            return employeeCellConfigurator?.reuseIdentifier ?? ""
        case .contacts:
            return contactsCellConfigurator?.reuseIdentifier ?? ""
        }
    }

    func configuredCell(for item: BusinessCardDetails.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .sectionHeader:
            return sectionHeaderConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .userInfo(let model):
            return headerInfoCellConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .getInTouch:
            return getInTouchCellConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .socialList:
            return socialListConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .addressInfo(let model):
            return addressInfoCellConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .map(let path):
            return mapCellConfigurator?.configuredCell(for: path, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .mapDirection:
            return mapDirectionCellConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .companyDescription(let text):
            return expandableDescriptionCellConfigurator?.configuredCell(for: text, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .title(let text):
            return sectionTitleConfigurator?.configuredCell(for: text, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .employee(let model):
            return employeeCellConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case .contacts(let model):
            return contactsCellConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        }
    }

    func registerCells(in tableView: UITableView) {
        headerInfoCellConfigurator?.registerCells(in: tableView)
        sectionTitleConfigurator?.registerCells(in: tableView)
        sectionHeaderConfigurator?.registerCells(in: tableView)
        getInTouchCellConfigurator?.registerCells(in: tableView)
        socialListConfigurator?.registerCells(in: tableView)
        expandableDescriptionCellConfigurator?.registerCells(in: tableView)
        mapDirectionCellConfigurator?.registerCells(in: tableView)
        mapCellConfigurator?.registerCells(in: tableView)
        addressInfoCellConfigurator?.registerCells(in: tableView)
        employeeCellConfigurator?.registerCells(in: tableView)
        contactsCellConfigurator?.registerCells(in: tableView)
    }


}

// MARK: - BusinessCardDetailsPresenter

extension BusinessCardDetailsPresenter {

    var dataSouceConfigurator: BusinessCardDetailsDataSourceConfigurator {
        get {
            var configurator = BusinessCardDetailsDataSourceConfigurator()

            // EmployeCellConfigurator
            configurator.employeeCellConfigurator = CellConfigurator { (cell, model: EmployeeModel?, tableView, indexPath) -> CardItemTableViewCell in
                cell.avatarImageView.setTextPlaceholderImage(withPath: model?.avatar, placeholderText: model?.nameAbbreviation)
                cell.type = .personal
                cell.nameLabel.text = "\(model?.firstName ?? "") \(model?.lastName ?? "")"
                cell.professionLabel.text = model?.practiceType?.title
                cell.telNumberLabel.text = model?.telephone

                return cell
            }

            // headerInfoCellConfigurator
            configurator.headerInfoCellConfigurator = CellConfigurator { (cell, model: BusinessCardDetails.HeaderInfoModel?, tableView, indexPath) -> BusinessCardHeaderInfoTableViewCell in
                cell.bgImageView.setImage(withPath: model?.bgimagePath)
                cell.avatarImageView.setImage(withPath: model?.avatartImagePath)
                cell.nameLabel.text = model?.name
                cell.professionLabel.text = model?.profession
                cell.telephoneNumberLabel.text = model?.telephoneNumber
                cell.websiteLabel.text = model?.websiteAddress

                return cell
            }

            // sectionTitleConfigurator
            configurator.sectionTitleConfigurator = CellConfigurator { (cell, model: String, tableView, indexPath) -> SectionTitleTableViewCell in
                cell.titleLabel.text = model
                return cell
            }

            // getInTouchCellConfigurator
            configurator.sectionHeaderConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> SectionHeaderTableViewCell in
                return cell
            }

            configurator.getInTouchCellConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> GetInTouchTableViewCell in
                cell.delegate = self
                return cell
            }

            // socialListConfigurator
            configurator.socialListConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> SocialsListTableViewCell in
                cell.delegate = self
                cell.dataSource = self
                cell.isEditable = false
                return cell
            }

            // expandableDescriptionCellConfigurator
            configurator.expandableDescriptionCellConfigurator = CellConfigurator { (cell, model: String?, tableView, indexPath) -> ExpandableDescriptionTableViewCell in
                cell.textDescriptionLabel.text = model
                return cell
            }

            // mapDirectionCellConfigurator
            configurator.mapDirectionCellConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> MapDirectionTableViewCell in
                cell.delegate = self.view
                return cell
            }

            // mapCellConfigurator
            configurator.mapCellConfigurator = CellConfigurator { (cell, model: String?, tableView, indexPath) -> MapTableViewCell in
                cell.isSetupUserCurrentLocationByMarker = true
                cell.mapView.isUserInteractionEnabled = false
                cell.delegate = self
                return cell
            }

            // addressInfoCellConfigurator
            configurator.addressInfoCellConfigurator = CellConfigurator { (cell, model: AddressInfoCellModel, tableView, indexPath) -> AddressInfoTableViewCell in
                cell.mainAddressLabel.text = model.mainAddress
                cell.subadressLabel.text = model.subAdress
                cell.scheduleLabel.text = model.schedule
                return cell
            }

            // contactsCellConfigurator
            configurator.contactsCellConfigurator = CellConfigurator { (cell, model: ContactsModel?, tableView, indexPath) -> ContactsTableViewCell in
                cell.telephoneNumberLabel.text = model?.telNumber
                cell.websiteLabel.text = model?.website
                cell.emailLabel.text = model?.email
                return cell
            }

            return configurator
        }
    }


}
