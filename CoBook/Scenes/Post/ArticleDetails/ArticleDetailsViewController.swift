//
//  ArticleDetailsViewController.swift
//  CoBook
//
//  Created by protas on 5/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!

    var presenter: ArticleDetailsPresenter?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.attachView(self)
        presenter?.fetchDetails()
    }

    // MARK: - Public
    

}

// MARK: - ArticleDetailsView

extension ArticleDetailsViewController: ArticleDetailsView {

}
