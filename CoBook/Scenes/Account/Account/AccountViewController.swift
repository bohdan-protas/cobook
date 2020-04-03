//
//  AccountViewController.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class AccountViewController: BaseViewController, AccountView {

    enum Defaults {
        static let estimatedRowHeight: CGFloat = 44
    }

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!

    // MARK: Properties
    var presenter = AccountPresenter()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        presenter.onViewDidLoad()
        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.onDidAppear()
    }

    deinit {
        presenter.detachView()
    }


}

// MARK: - Privates
private extension AccountViewController {

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

