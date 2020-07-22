//
//  NotificationsListConfigurator.swift
//  CoBook
//
//  Created by Bogdan Protas on 22.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

struct NotificationsListConfigurator: TableCellConfiguratorType {

    let notificationItemConfigurator: TableCellConfigurator<NotificationsList.Model, NotificationItemTableViewCell>
    
    func reuseIdentifier(for item: NotificationsList.Item, indexPath: IndexPath) -> String {
        switch item {
        case .notification:
            return notificationItemConfigurator.reuseIdentifier
        }
    }

    func configuredCell(for item: NotificationsList.Item, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch item {
        case .notification(let model):
            return notificationItemConfigurator.configuredCell(for: model, tableView: tableView, indexPath: indexPath)
        }
    }
    
    func registerCells(in tableView: UITableView) {}
    
}
