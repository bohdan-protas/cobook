//
//  UpdateAccountCellsConfigurator.swift
//  CoBook
//
//  Created by protas on 5/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

enum UpdateAccount {

    enum Cell {
        case sectionHeader

        case title(text: String)
    }


}

//struct UpdateAccountCellsConfigutator: CellConfiguratorType {
//
//    let sectionTitleConfigurator: CellConfigurator<String, SectionTitleTableViewCell>
//    let sectionSeparatorConfigurator: CellConfigurator<Void?, SectionHeaderTableViewCell>
//    let avatarManagmentConfigurator: CellConfigurator<CardAvatarManagmentCellModel, CardAvatarPhotoManagmentTableViewCell>?
//
//    func reuseIdentifier(for item: PersonalCardDetails.Cell, indexPath: IndexPath) -> String {
//        switch item {
//        case .sectionHeader:
//            return sectionHeaderConfigurator.reuseIdentifier
//        case .title:
//            return sectionTitleConfigurator.reuseIdentifier
//        case .userInfo:
//            return userInfoCellConfigurator.reuseIdentifier
//        case .getInTouch:
//            return getInTouchCellConfigurator.reuseIdentifier
//        case .socialList:
//            return socialListConfigurator.reuseIdentifier
//        case .personDescription:
//            return titleDescriptionCellConfigurator.reuseIdentifier
//        }
//    }
//
//    func configuredCell(for item: PersonalCardDetails.Cell, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
//        switch item {
//        case .sectionHeader:
//            return sectionHeaderConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
//        case .title(let text):
//            return sectionTitleConfigurator.configuredCell(for: text, tableView: tableView, indexPath: indexPath)
//        case .userInfo(let model):
//            return userInfoCellConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
//        case .getInTouch:
//            return getInTouchCellConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
//        case .socialList:
//            return socialListConfigurator.configuredCell(for: nil, tableView: tableView, indexPath: indexPath)
//        case .personDescription(let model):
//            return titleDescriptionCellConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
//        }
//    }
//
//    func registerCells(in tableView: UITableView) {
//        sectionTitleConfigurator.registerCells(in: tableView)
//        sectionHeaderConfigurator.registerCells(in: tableView)
//        userInfoCellConfigurator.registerCells(in: tableView)
//        getInTouchCellConfigurator.registerCells(in: tableView)
//        socialListConfigurator.registerCells(in: tableView)
//        titleDescriptionCellConfigurator.registerCells(in: tableView)
//    }
//}
