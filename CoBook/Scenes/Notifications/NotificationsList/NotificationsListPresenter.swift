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
    func reload(withScrollingToTop: Bool)
    
    func showBottomLoaderView()
    func hideBottomLoaderView()
}

fileprivate enum Defaults {
    static let paginationPageSize: UInt = 15
}

class NotificationsListPresenter: BasePresenter {
    
    weak var view: NotificationsListView?
    
    private var dataSource: TableDataSource<NotificationsListConfigurator>?
    private var notifications: PaginationPage<NotificationsList.Model>
        
    init() {
        self.notifications = PaginationPage(pageSize: Defaults.paginationPageSize, items: [])
    }
    
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

        notifications = PaginationPage(pageSize: Defaults.paginationPageSize, items:  [])
        notifications.isFetching = true
        
        fetchNotifications(by: notifications) { [weak self] (result) in
            guard let self = self else { return }
            
            self.notifications.isFetching = false
            self.view?.stopLoading()
            
            switch result {
            case .success(let notifications):
                self.notifications.append(items: notifications ?? [])
                self.updateViewSections()
                self.view?.reload(withScrollingToTop: true)
            case .failure(let error):
                self.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func cellWillDisplayAt(indexPath: IndexPath) {
        if notifications.items.count - 1 == indexPath.row && notifications.isNeedToLoadNextPage && !notifications.isFetching {
            
            notifications.isFetching = true
            view?.showBottomLoaderView()
            
            fetchNotifications(by: notifications) { [weak self] (result) in
                guard let self = self else { return }
                
                self.notifications.isFetching = false
                self.view?.showBottomLoaderView()
                
                switch result {
                case .success(let notifications):
                    self.notifications.append(items: notifications ?? [])
                    self.updateViewSections()
                    self.view?.reload(withScrollingToTop: false)
                case .failure(let error):
                    self.view?.errorAlert(message: error.localizedDescription)
                }
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
        
    
}

// MARK: - Privates

private extension NotificationsListPresenter {
    
    func fetchNotifications(by paginationPage: PaginationPage<NotificationsList.Model>,
                            completion: @escaping (Result<[NotificationsList.Model]?>) -> Void) {
        
        APIClient.default.getNofificationsList(limit: Int(paginationPage.pageSize), offset: Int(paginationPage.offset)) { (result) in
            switch result {
            case .success(let list):
                let notifications = (list ?? []).compactMap {
                    NotificationsList.Model(
                        id: $0.id,
                        title: $0.title,
                        body: $0.body,
                        createdAt: $0.createdAt,
                        creator: $0.createdBy,
                        photos: $0.photos?.compactMap { $0.sourceUrl }
                    )
                }
                completion(.success(notifications))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateViewSections() {
        let notificationsSection = Section<NotificationsList.Item>(
            items: notifications.items.compactMap { .notification(model: $0) }
        )
        dataSource?.sections = [notificationsSection]
    }
    
    
}
