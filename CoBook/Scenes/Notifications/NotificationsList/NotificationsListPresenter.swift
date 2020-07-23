//
//  NotificationsListPresenter.swift
//  CoBook
//
//  Created by Bogdan Protas on 22.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol NotificationsListView: AlertDisplayableView, LoadDisplayableView, NotificationItemCellDelegate, NotificationItemCellDataSource {
    func set(dataSource: TableDataSource<NotificationsListConfigurator>?)
    func reload()
}

class NotificationsListPresenter: BasePresenter {
    
    weak var view: NotificationsListView?
    
    private var dataSource: TableDataSource<NotificationsListConfigurator>?
    private var notifications: [NotificationsList.Model] = []
        
    // MARK: - Base Presenter
    
    func attachView(_ view: NotificationsListView) {
        self.view = view
        self.dataSource = TableDataSource(sections: [], configurator: configurator)
        self.view?.set(dataSource: dataSource)
    }
    
    func detachView() {
        self.view = nil
    }
    
    // MARK: - Public
    
    func fetchNotifications(usingLoader: Bool) {
        if usingLoader {
            view?.startLoading()
        }
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
    
    func photosList(at indexPath: IndexPath) -> [String] {
        guard let item = dataSource?.sections[safe: indexPath.section]?.items[safe: indexPath.item] else {
            return []
        }
        switch item {
        case .notification(let model):
            return model.photos ?? []
        }
    }
    
    func onNotificationPhotoTap(at indexPath: IndexPath) {
        
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
