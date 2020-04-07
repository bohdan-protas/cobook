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
    static let hideCardViewHeight: CGFloat = 84
}

class BusinessCardDetailsViewController: BaseViewController, BusinessCardDetailsView {

    @IBOutlet var tableView: UITableView!

    var presenter: BusinessCardDetailsPresenter?
    var dataSource: TableDataSource<BusinessCardDetailsDataSourceConfigurator>?

    private lazy var hideCardView: EditCardView = {
        let view = EditCardView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.hideCardViewHeight)))
        view.onEditTapped = { [weak self] in
            //self?.presenter?.editPerconalCard()
        }
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

    // MARK: - BusinessCardDetailsView
    func setupLayout() {
        navigationItem.title = "Бізнес візитка"
        tableView.delegate = self
    }

    func configureDataSource(with configurator: BusinessCardDetailsDataSourceConfigurator) {
        dataSource = TableDataSource(tableView: self.tableView, configurator: configurator)
        tableView.dataSource = dataSource
        tableView.tableFooterView = hideCardView
    }

    func updateDataSource(sections: [Section<BusinessCardDetails.Cell>]) {
        dataSource?.sections = sections
        tableView.reloadData()
    }

    func sendEmail(to address: String) {
        
    }


}

// MARK: - UITableViewDelegate
extension BusinessCardDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

}
