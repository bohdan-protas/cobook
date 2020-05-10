//
//  PersonalCardDetailsViewController.swift
//  CoBook
//
//  Created by protas on 3/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import MessageUI

fileprivate enum Layout {
    static let estimatedRowHeight: CGFloat = 44
    static let footerHeight: CGFloat = 84
}

class PersonalCardDetailsViewController: BaseViewController, PersonalCardDetailsView {

    @IBOutlet var tableView: UITableView!

    var presenter: PersonalCardDetailsPresenter?


    private lazy var editCardView: EditCardView = {
        let view = EditCardView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Layout.footerHeight)))
        view.onEditTapped = { [weak self] in
            self?.presenter?.editPerconalCard()
        }
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.setupDataSource()
    }

    deinit {
        presenter?.detachView()
    }

    // MARK: - PersonalCardDetailsView

    func setupLayout() {
        navigationItem.title = "Персональна візитка"
        tableView.delegate = self
        tableView.tableFooterView = editCardView
    }

    func set(dataSource: DataSource<PersonalCardDetailsDataSourceConfigurator>?) {
        dataSource?.connect(to: tableView)
    }

    func reload() {
        tableView.reloadData()
    }


}

// MARK: - Privates

private extension PersonalCardDetailsViewController {

}

// MARK: - UITableViewDelegate

extension PersonalCardDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

}
