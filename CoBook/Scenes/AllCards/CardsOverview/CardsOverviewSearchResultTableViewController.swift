//
//  CardsOverviewSearchResultTableViewController.swift
//  CoBook
//
//  Created by protas on 4/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


class CardsOverviewSearchResultTableViewController: UITableViewController {

    lazy var headerView: SearchResultHeaderView = {
        let view = SearchResultHeaderView(frame: CGRect(origin: .zero, size: CGSize(width: self.tableView.frame.width, height: 30)))
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView = headerView
    }

    func set(resultsLabel text: String) {
        headerView.resultsLabel.text = text
    }


}
