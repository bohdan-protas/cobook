//
//  AccountViewController.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

private enum Defaults {
    static let estimatedRowHeight: CGFloat = 44
}

class AccountViewController: BaseViewController, AccountView {

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!

    // MARK: Properties
    var presenter = AccountPresenter()
    var dataSource: TableDataSource<AccountDataSourceConfigurator>?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        presenter.onViewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.onDidAppear()
    }

    deinit {
        presenter.detachView()
    }

    // MARK: - AccountView
    func setupLayout() {
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Defaults.estimatedRowHeight
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)

        let footerView = UIView(frame: CGRect(origin: .zero, size: .init(width: tableView.frame.width, height: 8)))
        footerView.backgroundColor = .white
        tableView.tableFooterView = footerView
        tableView.delegate = self
    }

    func configureDataSource(with configurator: AccountDataSourceConfigurator) {
        dataSource = TableDataSource(tableView: self.tableView, configurator: configurator)
        tableView.dataSource = dataSource
    }

    func updateDataSource(sections: [Section<Account.Item>]) {
        dataSource?.sections = sections
        tableView.reloadData()
    }


}

// MARK: - UITableViewDelegate
extension AccountViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.selectedRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }


}

