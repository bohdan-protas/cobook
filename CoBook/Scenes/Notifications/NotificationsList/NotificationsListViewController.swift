//
//  NotificationsListViewController.swift
//  CoBook
//
//  Created by Bogdan Protas on 22.07.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class NotificationsListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        // Do any additional setup after loading the view.
    }
    

}

// MARK: - Privates

private extension NotificationsListViewController {

    func setupLayout() {
//        self.tableView.delegate = self
//        self.tableView.refreshControl = refreshControl
        self.navigationItem.title = "NotificationsList.title".localized
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    }


}

// MARK: - NotificationsListView

extension NotificationsListViewController: NotificationsListView {
    
    func set(dataSource: TableDataSource<NotificationsListConfigurator>?) {
        
    }
    
    
}
