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
        static let headerHeight: CGFloat = 308
        static let footerHeight: CGFloat = 124
        static let sectionHeaderHeight: CGFloat = 28
    }

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!

    // MARK: Properties
    var presenter = AccountPresenter()


    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)

        setupLayout()
        presenter.setup()
    }

    deinit {
        presenter.detachView()
    }

    // MARK: Public
    func fillHeader(with profile: Profile?) {
        (tableView.tableHeaderView as? AccountHeaderView)?.fill(with: profile)
    }

    func startLoading() {

    }

    func stopLoading() {

    }

    func push(controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }


}

// MARK: - Privates
private extension AccountViewController {

    func setupLayout() {
        tableView.register(AccountBusinessCardTableViewCell.nib, forCellReuseIdentifier: AccountBusinessCardTableViewCell.identifier)
        tableView.register(AccountItemTableViewCell.nib, forCellReuseIdentifier: AccountItemTableViewCell.identifier)

        tableView.tableHeaderView = AccountHeaderView(frame:  CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: Defaults.headerHeight))
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
        presenter.selectedRow(at: indexPath)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return SectionHeaderSeparatorView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Defaults.sectionHeaderHeight
    }


}

