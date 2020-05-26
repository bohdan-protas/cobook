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

    private lazy var empeyBottomCardView: EditCardView = {
        let view = EditCardView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Layout.footerHeight)))
        view.editButton.setTitle("", for: .normal)
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        presenter?.attachView(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.setupDataSource()
    }

    deinit {
        presenter?.detachView()
    }

    // MARK: - Actions
    
    @objc func shareTapped() {
        presenter?.share()
    }

    // MARK: - PersonalCardDetailsView

    func setupLayout() {
        navigationItem.title = "Персональна візитка"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_share"), style: .plain, target: self, action: #selector(shareTapped))
        tableView.delegate = self
    }

    func setupEditView() {
        tableView.tableFooterView = editCardView
    }

    func setupEmptyBottomView() {
        tableView.tableFooterView = empeyBottomCardView
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
