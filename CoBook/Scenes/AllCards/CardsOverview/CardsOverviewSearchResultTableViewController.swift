//
//  CardsOverviewSearchResultTableViewController.swift
//  CoBook
//
//  Created by protas on 4/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


class CardsOverviewSearchResultTableViewController: UITableViewController {

    var dataSource: TableDataSource<CardsOverviewViewDataSourceConfigurator>?

    lazy var headerView: SearchResultHeaderView = {
        let view = SearchResultHeaderView(frame: CGRect(origin: .zero, size: CGSize(width: self.tableView.frame.width, height: 30)))
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView = headerView
    }

    func configureDataSource(with configurator: CardsOverviewViewDataSourceConfigurator) {
        dataSource = TableDataSource(tableView: self.tableView, configurator: configurator)
        tableView.dataSource = dataSource
    }

    func setup(sections: [Section<CardsOverview.Items>]) {
        dataSource?.sections = sections

        let items = sections.flatMap { $0.items }
        headerView.resultsLabel.text = items.isEmpty ?
            "Немає результатів пошуку" :
            "Знайдено: \(items.count)"

        tableView.reloadData()
    }


}
