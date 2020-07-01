//
//  FinanceStatisticsViewController.swift
//  CoBook
//
//  Created by Bogdan Protas on 30.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class FinanceStatisticsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var presenter = FinanceStatisticsPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}

// MARK: - FinanceStatisticsView

extension FinanceStatisticsViewController: FinanceStatisticsView {
    
}
