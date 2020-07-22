//
//  NotificationsListConfigurator.swift
//  CoBook
//
//  Created by Bogdan Protas on 22.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct NotificationsListConfigurator: TableCellConfiguratorType {

    //let cardHistoryPreviewCellConfigurator: TableCellConfigurator<LeaderboardStatAPIModel, CardPreviewTableViewCell>
    
    func reuseIdentifier(for item: NotificationsList.Item, indexPath: IndexPath) -> String {
        switch item {
        case .notification:
            return ""
        }
    }

    func configuredCell(for item: NotificationsList.Item, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .notification(let model):
            return UITableViewCell()
        }
    }
    
    func registerCells(in tableView: UITableView) {
        
    }
    
}
