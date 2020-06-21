//
//  CardStatisticsViewController.swift
//  CoBook
//
//  Created by Bogdan Protas on 21.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CardStatisticsViewController: BaseViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    var presenter = CardStaticticsPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        presenter.view = self
        presenter.setup()
    }
    
    private func setupLayout() {
        self.navigationItem.title = "Статистика візиток"
    }
    
}

// MARK: - CardSaveView

extension CardStatisticsViewController: CardStatisticsView {
    
    func set(dataSource: TableDataSource<CardStatisticsCellsConfigurator>?) {
        dataSource?.connect(to: tableView)
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    
}
