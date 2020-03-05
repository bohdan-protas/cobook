//
//  AccountViewController.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, AccountView {

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

        self.setup()
        presenter.setup()
    }

    deinit {
        presenter.detachView()
    }

    // MARK: Public
    func startLoading() {

    }

    func stopLoading() {

    }


}

// MARK: - Privates
private extension AccountViewController {
    func setup() {
        tableView.register(AccountBusinessCardTableViewCell.nib, forCellReuseIdentifier: AccountBusinessCardTableViewCell.identifier)
        tableView.register(AccountItemTableViewCell.nib, forCellReuseIdentifier: AccountItemTableViewCell.identifier)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Defaults.estimatedRowHeight

        tableView.dataSource = presenter.dataSource
        tableView.delegate = self
    }
}

// MARK: - UITableViewDelegate
extension AccountViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }

}

