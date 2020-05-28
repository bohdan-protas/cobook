//
//  PersonalCardDetailsDataSourceConfigurator.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct PersonalCardDetailsDataSourceConfigurator: CellConfiguratorType {

    let sectionTitleConfigurator: CellConfigurator<String, SectionTitleTableViewCell>
    let sectionHeaderConfigurator: CellConfigurator<Void?, SectionHeaderTableViewCell>
    let userInfoCellConfigurator: CellConfigurator<CardDetailsApiModel?, PersonalCardUserInfoTableViewCell>
    let getInTouchCellConfigurator: CellConfigurator<Void?, GetInTouchTableViewCell>
    let socialListConfigurator: CellConfigurator<Void?, SocialsListTableViewCell>
    let titleDescriptionCellConfigurator: CellConfigurator<TitleDescrModel?, ExpandableDescriptionTableViewCell>
    let postPreviewConfigurator: CellConfigurator<PostPreview.Section?, AlbumPreviewItemsTableViewCell>
    let actionTitleConfigurator: CellConfigurator<ActionTitleModel, ActionTitleTableViewCell>

    func reuseIdentifier(for item: PersonalCardDetails.Cell, indexPath: IndexPath) -> String {
        switch item {
        case .sectionHeader:
            return sectionHeaderConfigurator.reuseIdentifier
        case .title:
            return sectionTitleConfigurator.reuseIdentifier
        case .userInfo:
            return userInfoCellConfigurator.reuseIdentifier
        case .getInTouch:
            return getInTouchCellConfigurator.reuseIdentifier
        case .socialList:
            return socialListConfigurator.reuseIdentifier
        case .personDescription:
            return titleDescriptionCellConfigurator.reuseIdentifier
        case .postPreview:
            return postPreviewConfigurator.reuseIdentifier
        case .actionTitle:
            return actionTitleConfigurator.reuseIdentifier
        }
    }

    func configuredCell(for item: PersonalCardDetails.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .sectionHeader:
            return sectionHeaderConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
        case .title(let text):
            return sectionTitleConfigurator.configuredCell(for: text, tableView: tableView, indexPath: indexPath)
        case .userInfo(let model):
            return userInfoCellConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .getInTouch:
            return getInTouchCellConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
        case .socialList:
            return socialListConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
        case .personDescription(let model):
            return titleDescriptionCellConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .postPreview(let model):
            return postPreviewConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        case .actionTitle(let model):
            return actionTitleConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        }
    }

    func registerCells(in tableView: UITableView) {
        sectionTitleConfigurator.registerCells(in: tableView)
        sectionHeaderConfigurator.registerCells(in: tableView)
        userInfoCellConfigurator.registerCells(in: tableView)
        getInTouchCellConfigurator.registerCells(in: tableView)
        socialListConfigurator.registerCells(in: tableView)
        titleDescriptionCellConfigurator.registerCells(in: tableView)
        postPreviewConfigurator.registerCells(in: tableView)
        actionTitleConfigurator.registerCells(in: tableView)
    }
}

extension PersonalCardDetailsPresenter {

    var dataSourceConfigurator: PersonalCardDetailsDataSourceConfigurator {
        get {

            let sectionTitleConfigurator = CellConfigurator { (cell, model: String, tableView, indexPath) -> SectionTitleTableViewCell in
                cell.titleLabel.text = model
                return cell
            }

            let sectionHeaderConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> SectionHeaderTableViewCell in
                return cell
            }

            let userInfoCellConfigurator = CellConfigurator { (cell, model: CardDetailsApiModel?, tableView, indexPath) -> PersonalCardUserInfoTableViewCell in
                cell.delegate = self

                let abbr = "\(model?.cardCreator?.firstName?.first?.uppercased() ?? "") \(model?.cardCreator?.lastName?.first?.uppercased() ?? "")"
                let textImg = abbr.image(size: cell.avatarImageView.frame.size)
                cell.avatarImageView.setImage(withPath: model?.avatar?.sourceUrl, placeholderImage: textImg)
                cell.userNameLabel.text = "\(model?.cardCreator?.firstName ?? "") \(model?.cardCreator?.lastName ?? "")"
                cell.practiceTypeLabel.text = model?.practiceType?.title
                cell.positionLabel.text = model?.position
                cell.telephoneNumberLabel.text = model?.city?.name
                cell.detailInfoTextView.text = model?.description
                cell.saveButton.isSelected = model?.isSaved ?? false
                return cell
            }

            let getInTouchCellConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> GetInTouchTableViewCell in
                cell.delegate = self
                return cell
            }

            let socialListConfigurator = CellConfigurator { (cell, model: Void?, tableView, indexPath) -> SocialsListTableViewCell in
                cell.delegate = self
                cell.dataSource = self
                cell.isEditable = false
                return cell
            }

            // expandableDescriptionCellConfigurator
            let titleDescriptionCellConfigurator = CellConfigurator { (cell, model: TitleDescrModel?, tableView, indexPath) -> ExpandableDescriptionTableViewCell in
                cell.titleLabel.attributedText = NSAttributedString(string: model?.title ?? "", attributes: [.foregroundColor: UIColor.Theme.blackMiddle, .font: UIFont.SFProDisplay_Medium(size: 15)])
                cell.desctiptionTextView.text = model?.descr
                return cell
            }

            // postPreviewConfigurator
            let postPreviewConfigurator = CellConfigurator { (cell, model: PostPreview.Section?, tableView, indexPath) -> AlbumPreviewItemsTableViewCell in
                cell.topConstaint.constant = 0
                cell.separatorView.isHidden = true
                cell.dataSourceID = model?.dataSourceID
                cell.delegate = self
                cell.dataSource = self
                cell.collectionView.reloadData()
                return cell
            }

            // actionTitleConfigurator
            let actionTitleConfigurator = CellConfigurator { (cell, model: ActionTitleModel, tableView, indexPath) -> ActionTitleTableViewCell in
                cell.titleLabel.text = model.title
                cell.countLabel.text = "\( model.counter ?? 0)"
                cell.actionButton.setTitle(model.actionTitle, for: .normal)
                cell.actionHandler = model.actionHandler
                return cell
            }

            return PersonalCardDetailsDataSourceConfigurator(sectionTitleConfigurator: sectionTitleConfigurator,
                                                             sectionHeaderConfigurator: sectionHeaderConfigurator,
                                                             userInfoCellConfigurator: userInfoCellConfigurator,
                                                             getInTouchCellConfigurator: getInTouchCellConfigurator,
                                                             socialListConfigurator: socialListConfigurator,
                                                             titleDescriptionCellConfigurator: titleDescriptionCellConfigurator,
                                                             postPreviewConfigurator: postPreviewConfigurator,
                                                             actionTitleConfigurator: actionTitleConfigurator)

        }
    }


}
