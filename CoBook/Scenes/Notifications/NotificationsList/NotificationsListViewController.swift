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

        // Do any additional setup after loading the view.
    }
    

}

// MARK: - NotificationsListView

extension NotificationsListViewController: NotificationsListView {
    
    func set(dataSource: TableDataSource<NotificationsListConfigurator>?) {
        
    }
    
    
}
