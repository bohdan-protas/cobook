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

extension NotificationsListPresenter {
    
    var configurator: NotificationsListConfigurator {
        get {
            let notificationItemConfigurator = TableCellConfigurator { [weak self] (cell, model: NotificationsList.Model, tableView, indexPath) -> NotificationItemTableViewCell in
                cell.titleLabel.text = model.title
                cell.bodyLabel.text = model.body
                cell.associatedIndexPath = indexPath
                cell.delegate = self?.view
                cell.dataSource = self?.view
                cell.photosCollectionView.reloadData()
                cell.photosContainerView.isHidden = model.photos?.isEmpty ?? true
                
                if let date = model.createdAt {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    cell.dateLabel.text = formatter.string(from: date)
                } else {
                    cell.dateLabel.text = ""
                }
                return cell
            }
            
            let configurator = NotificationsListConfigurator(notificationItemConfigurator: notificationItemConfigurator)
            return configurator
        }
    }
    
}




