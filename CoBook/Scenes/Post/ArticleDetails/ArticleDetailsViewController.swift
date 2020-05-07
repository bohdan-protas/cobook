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
        presenter?.setup()
        presenter?.fetchDetails()
    }

    deinit {
        presenter?.detachView()
    }


}

// MARK: - Privates

extension ArticleDetailsViewController {

    func setupLayout() {
        tableView.delegate = self
    }

}

// MARK: - ArticleDetailsView

extension ArticleDetailsViewController: ArticleDetailsView {

    func set(title: String?) {
        self.navigationItem.title = title
    }

    func reload() {
        tableView.reloadData()
    }

    func set(dataSource: DataSource<ArticleDetailsCellConfigutator>?) {
        dataSource?.connect(to: tableView)
        tableView.reloadData()
    }


}

// MARK: - UITableViewDelegate

extension ArticleDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}


