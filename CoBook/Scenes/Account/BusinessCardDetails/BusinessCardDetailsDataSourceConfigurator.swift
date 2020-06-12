//
//  BusinessCardDetailsDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


struct BusinessCardDetailsDataSourceConfigurator: TableCellConfiguratorType {

    var headerInfoCellConfigurator: TableCellConfigurator<BusinessCardDetails.HeaderInfoModel, BusinessCardHeaderInfoTableViewCell>?
    var sectionTitleConfigurator: TableCellConfigurator<String, SectionTitleTableViewCell>?
    var sectionHeaderConfigurator: TableCellConfigurator<Void?, SectionHeaderTableViewCell>?
    var getInTouchCellConfigurator: TableCellConfigurator<Void?, GetInTouchTableViewCell>?
    var socialListConfigurator: TableCellConfigurator<Void?, SocialsListTableViewCell>?
    var expandableDescriptionCellConfigurator: TableCellConfigurator<TitleDescrModel?, ExpandableDescriptionTableViewCell>?
    var mapDirectionCellConfigurator: TableCellConfigurator<Void?, MapDirectionTableViewCell>?
    var mapCellConfigurator: TableCellConfigurator<String, StaticMapTableViewCell>?
    var addressInfoCellConfigurator: TableCellConfigurator<AddressInfoCellModel, AddressInfoTableViewCell>?
    var employeeCellConfigurator: TableCellConfigurator<EmployeeModel?, CardItemTableViewCell>?
    var contactsCellConfigurator: TableCellConfigurator<ContactsModel?, ContactsTableViewCell>?
    var serviceItemCellConfigurator: TableCellConfigurator<Service.PreviewListItem, ServiceListItemTableViewCell>?
    var addProductConfigurator: TableCellConfigurator<Void?, ServiceListItemTableViewCell>?
    var productSectionConfigurator: TableCellConfigurator<ProductPreviewSectionModel, ProductPreviewItemsHorizontalListTableViewCell>?
    var postPreviewConfigurator: TableCellConfigurator<PostPreview.Section?, AlbumPreviewItemsTableViewCell>?
    var actionTitleConfigurator: TableCellConfigurator<ActionTitleModel, ActionTitleTableViewCell>?

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
        case .service:
            return serviceItemCellConfigurator?.reuseIdentifier ?? ""
        case .addProduct:
            return addProductConfigurator?.reuseIdentifier ?? ""
        case .productSection:
            return productSectionConfigurator?.reuseIdentifier ?? ""
        case .postPreview:
            return postPreviewConfigurator?.reuseIdentifier ?? ""
        case .actionTitle:
            return actionTitleConfigurator?.reuseIdentifier ?? ""
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

        case .companyDescription(let model):
            return expandableDescriptionCellConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .title(let text):
            return sectionTitleConfigurator?.configuredCell(for: text, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .employee(let model):
            return employeeCellConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .contacts(let model):
            return contactsCellConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .service(let model):
            return serviceItemCellConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .addProduct:
            return addProductConfigurator?.configuredCell(for: nil, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .productSection(let model):
            return productSectionConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .postPreview(let model):
            return postPreviewConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()

        case .actionTitle(let model):
            return actionTitleConfigurator?.configuredCell(for: model, tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
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
        serviceItemCellConfigurator?.registerCells(in: tableView)
        addProductConfigurator?.registerCells(in: tableView)
        productSectionConfigurator?.registerCells(in: tableView)
        postPreviewConfigurator?.registerCells(in: tableView)
        actionTitleConfigurator?.registerCells(in: tableView)
    }


}

// MARK: - BusinessCardDetailsPresenter

extension BusinessCardDetailsPresenter {

    /// Dependency injection to BusinessCardDetailsPresenter
    var dataSouceConfigurator: BusinessCardDetailsDataSourceConfigurator {
        get {
            var configurator = BusinessCardDetailsDataSourceConfigurator()

            // EmployeCellConfigurator
            configurator.employeeCellConfigurator = TableCellConfigurator { (cell, model: EmployeeModel?, tableView, indexPath) -> CardItemTableViewCell in

                let textImg = model?.nameAbbreviation?.image(size: cell.avatarImageView.frame.size)

                cell.avatarImageView.setImage(withPath: model?.avatar, placeholderImage: textImg)
                cell.type = .personal
                cell.nameLabel.text = "\(model?.firstName ?? "") \(model?.lastName ?? "")"
                cell.professionLabel.text = model?.practiceType?.title
                cell.telNumberLabel.text = model?.telephone

                return cell
            }

            // headerInfoCellConfigurator
            configurator.headerInfoCellConfigurator = TableCellConfigurator { (cell, model: BusinessCardDetails.HeaderInfoModel, tableView, indexPath) -> BusinessCardHeaderInfoTableViewCell in
                cell.delegate = self
                cell.bgImageView.setImage(withPath: model.bgimagePath)
                cell.avatarImageView.setImage(withPath: model.avatartImagePath)
                cell.nameLabel.text = model.name
                cell.professionLabel.text = model.profession
                cell.telephoneNumberLabel.text = model.telephoneNumber
                cell.websiteLabel.text = model.websiteAddress
                cell.saveCardButton.isSelected = model.isSaved


                return cell
            }

            // sectionTitleConfigurator
            configurator.sectionTitleConfigurator = TableCellConfigurator { (cell, model: String, tableView, indexPath) -> SectionTitleTableViewCell in
                cell.titleLabel.text = model
                return cell
            }

            // getInTouchCellConfigurator
            configurator.sectionHeaderConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> SectionHeaderTableViewCell in
                return cell
            }

            configurator.getInTouchCellConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> GetInTouchTableViewCell in
                cell.delegate = self
                return cell
            }

            // socialListConfigurator
            configurator.socialListConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> SocialsListTableViewCell in
                cell.delegate = self
                cell.dataSource = self
                cell.isEditable = false
                return cell
            }

            // expandableDescriptionCellConfigurator
            configurator.expandableDescriptionCellConfigurator = TableCellConfigurator { (cell, model: TitleDescrModel?, tableView, indexPath) -> ExpandableDescriptionTableViewCell in
                cell.titleLabel.attributedText = NSAttributedString(string: model?.title ?? "", attributes: [.foregroundColor: UIColor.Theme.blackMiddle, .font: UIFont.SFProDisplay_Medium(size: 20)])
                cell.desctiptionTextView.text = model?.descr

                return cell
            }

            // mapDirectionCellConfigurator
            configurator.mapDirectionCellConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> MapDirectionTableViewCell in
                cell.delegate = self.view
                return cell
            }

            // mapCellConfigurator
            configurator.mapCellConfigurator = TableCellConfigurator { (cell, model: String, tableView, indexPath) -> StaticMapTableViewCell in
                cell.activityIndicator.startAnimating()
                StaticMapConfiguratorService.constructStaticMapURL(mapSize: .init(width: cell.frame.width, height: cell.frame.height), center: model) { (url) in
                    cell.mapImageView?.setImage(withPath: url?.absoluteString)
                    cell.activityIndicator.stopAnimating()
                }
                return cell
            }

            // addressInfoCellConfigurator
            configurator.addressInfoCellConfigurator = TableCellConfigurator { (cell, model: AddressInfoCellModel, tableView, indexPath) -> AddressInfoTableViewCell in
                cell.mainAddressLabel.text = model.mainAddress
                cell.subadressLabel.text = model.subAdress
                cell.scheduleLabel.text = model.schedule
                return cell
            }

            // contactsCellConfigurator
            configurator.contactsCellConfigurator = TableCellConfigurator { (cell, model: ContactsModel?, tableView, indexPath) -> ContactsTableViewCell in
                cell.telephoneNumberLabel.text = model?.telNumber

                let websiteLabelAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.HelveticaNeueCyr_Roman(size: 15),
                    .foregroundColor: UIColor.Theme.greenDark,
                ]

                let attributeString = NSMutableAttributedString(string: model?.website ?? "", attributes: websiteLabelAttributes)

                cell.websiteButton.setAttributedTitle(attributeString, for: .normal)
                cell.emailLabel.text = model?.email
                return cell
            }

            // serviceItemCellConfigurator
            configurator.serviceItemCellConfigurator = TableCellConfigurator { (cell, model: Service.PreviewListItem, tableView, indexPath) -> ServiceListItemTableViewCell in
                switch model {
                case .view(let model):
                    cell.titleLabel.text = model.name
                    cell.subtitleLabel.text = model.price
                    cell.titleImageView.setImage(withPath: model.avatarPath)
                    cell.subtitleLabel.isHidden = false
                case .add:
                    cell.titleLabel.text = "Service.add.text".localized
                    cell.titleImageView.image = #imageLiteral(resourceName: "ic_add_item")
                    cell.subtitleLabel.isHidden = true
                }

                return cell
            }

            // addGoodsConfigurator
            configurator.addProductConfigurator = TableCellConfigurator { (cell, model: Void?, tableView, indexPath) -> ServiceListItemTableViewCell in
                cell.titleLabel.text = "Product.add.text".localized
                cell.titleImageView.image = #imageLiteral(resourceName: "ic_add_item")
                cell.subtitleLabel.isHidden = true
                return cell
            }

            // productSectionConfigurator
            configurator.productSectionConfigurator = TableCellConfigurator { (cell, model: ProductPreviewSectionModel, tableView, indexPath) -> ProductPreviewItemsHorizontalListTableViewCell in
                cell.delegate = self
                cell.headerLabel.text = model.headerTitle
                cell.dataSource = model.productPreviewItems
                cell.collectionView.reloadData()
                return cell
            }

            //
            configurator.postPreviewConfigurator = TableCellConfigurator { (cell, model: PostPreview.Section?, tableView, indexPath) -> AlbumPreviewItemsTableViewCell in
                cell.topConstaint.constant = 0
                cell.dataSourceID = model?.dataSourceID
                cell.delegate = self
                cell.dataSource = self
                cell.collectionView.reloadData()
                return cell
            }

            // actionTitleConfigurator
            configurator.actionTitleConfigurator = TableCellConfigurator { (cell, model: ActionTitleModel, tableView, indexPath) -> ActionTitleTableViewCell in
                cell.titleLabel.text = model.title
                cell.countLabel.text = "\( model.counter ?? 0)"
                cell.actionButton.setTitle(model.actionTitle, for: .normal)
                cell.actionHandler = model.actionHandler
                return cell
            }

            return configurator
        }
    }


}
