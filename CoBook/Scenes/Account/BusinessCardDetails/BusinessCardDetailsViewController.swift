//
//  BusinessCardDetailsViewController.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

private enum Defaults {
    static let estimatedRowHeight: CGFloat = 44
    static let hideCardViewHeight: CGFloat = 102
    static let editCardViewHeight: CGFloat = 84
}

class BusinessCardDetailsViewController: BaseViewController, BusinessCardDetailsView {

    @IBOutlet var tableView: UITableView!

    var presenter: BusinessCardDetailsPresenter?
    var dataSource: TableDataSource<BusinessCardDetailsDataSourceConfigurator>?

    private lazy var hideCardView: HideCardView = {
        let view = HideCardView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.hideCardViewHeight)))
        view.onHideTapped = { [weak self] in

        }
        return view
    }()

    private lazy var editCardView: EditCardView = {
        let view = EditCardView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.editCardViewHeight)))
        view.onEditTapped = { [weak self] in
            self?.presenter?.editBusinessCard()
        }
        return view
    }()

    private lazy var itemsBarView: HorizontalItemsBarView = {
        let view = HorizontalItemsBarView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: 58)), dataSource: [])

        view.delegate = self.presenter
        return view
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        presenter?.attachView(self)
        presenter?.onViewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }

    deinit {
        presenter?.detachView()
    }

    func setupLayout() {
        navigationItem.title = "Бізнес візитка"
        tableView.delegate = self
    }

    // MARK: - BusinessCardDetailsView

    func configureDataSource(with configurator: BusinessCardDetailsDataSourceConfigurator) {
        dataSource = TableDataSource(tableView: self.tableView, configurator: configurator)
        tableView.dataSource = dataSource
    }

    func updateDataSource(sections: [Section<BusinessCardDetails.Cell>]) {
        dataSource?.sections = sections
        tableView.tableFooterView = editCardView
        tableView.reloadData()
    }

    func sendEmail(to address: String) {
        
    }


}

// MARK: - UITableViewDelegate

extension BusinessCardDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return itemsBarView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return itemsBarView.frame.height
        }
        return 0
    }

}
