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
        
        presenter.attachView(self)
        presenter.setup()
    }
    
    private func setupLayout() {
        self.navigationItem.title = "Statistic.title".localized
        tableView.delegate = self
    }
    
}

// MARK: - UITableViewDelegate

extension CardStatisticsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.selectedItemAt(indexPath: indexPath)
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
