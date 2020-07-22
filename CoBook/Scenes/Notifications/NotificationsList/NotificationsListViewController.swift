//
//  NotificationsListViewController.swift
//  CoBook
//
//  Created by Bogdan Protas on 22.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class NotificationsListViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    var presenter: NotificationsListPresenter = NotificationsListPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        presenter.attachView(self)
        presenter.setup()
    }
    
    deinit {
        presenter.detachView()
    }
    

}

// MARK: - Privates

private extension NotificationsListViewController {

    func setupLayout() {
        self.tableView.delegate = self
//        self.tableView.refreshControl = refreshControl
        self.navigationItem.title = "NotificationsList.title".localized
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    }


}

// MARK: - UITableViewDelegate

extension NotificationsListViewController: UITableViewDelegate {
    
}

// MARK: - NotificationsListView

extension NotificationsListViewController: NotificationsListView {
    
    func set(dataSource: TableDataSource<NotificationsListConfigurator>?) {
        dataSource?.connect(to: tableView)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    
}
