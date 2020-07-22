//
//  NotificationsListPresenter.swift
//  CoBook
//
//  Created by Bogdan Protas on 22.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol NotificationsListView: class, AlertDisplayableView, LoadDisplayableView {
    func set(dataSource: TableDataSource<NotificationsListConfigurator>?)
    func reload()
}

class NotificationsListPresenter: BasePresenter {
    
    weak var view: NotificationsListView?
    
    private var dataSource: TableDataSource<NotificationsListConfigurator>?
    private var notifications: [NotificationsList.Model] = []
    
    // MARK: - Initializators
    
    init() {
        let notificationItemConfigurator = TableCellConfigurator { (cell, model: NotificationsList.Model, tableView, indexPath) -> NotificationItemTableViewCell in
            cell.titleLabel.text = model.title
            cell.bodyLabel.text = model.body
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
        self.dataSource = TableDataSource(sections: [], configurator: configurator)
    }
    
    // MARK: - Base Presenter
    
    func attachView(_ view: NotificationsListView) {
        self.view = view
        view.set(dataSource: dataSource)
    }
    
    func detachView() {
        self.view = nil
    }
    
    // MARK: - Public
    
    func setup() {
        view?.startLoading()
        APIClient.default.getNofificationsList(limit: 0, offset: 15) { [weak self] (result) in
            guard let self = self else { return }
            self.view?.stopLoading()
            switch result {
            case .success(let list):
                self.notifications = (list ?? []).compactMap {
                    NotificationsList.Model(
                        id: $0.id,
                        title: $0.title,
                        body: $0.body,
                        createdAt: $0.createdAt,
                        creator: $0.createdBy,
                        photos: $0.photos?.compactMap { $0.sourceUrl }
                    )
                }
                self.updateViewLayout()
                self.view?.reload()
            case .failure(let error):
                self.view?.stopLoading(success: false, completion: {
                    self.view?.errorAlert(message: error.localizedDescription)
                })
            }
        }
    }
    
    
}

// MARK: - Privates

private extension NotificationsListPresenter {
    
    func updateViewLayout() {
        let notificationsSection = Section<NotificationsList.Item>(
            items: notifications.compactMap { .notification(model: $0) }
        )
        dataSource?.sections = [notificationsSection]
    }
    
    
}
