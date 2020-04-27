//
//  ServiceDetailsViewController.swift
//  CoBook
//
//  Created by protas on 4/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit


private enum Defaults {
    static let editCardViewHeight: CGFloat = 84
}

class ServiceDetailsViewController: BaseViewController, ServiceDetailsView {

    // main table view
    @IBOutlet var tableView: UITableView!

    /// edit footer view
    private lazy var editCardFooterView: EditCardView = {
        let view = EditCardView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.editCardViewHeight)))
        view.editButton.setTitle("Редагувати послугу", for: .normal)
        view.onEditTapped = { [weak self] in
            //self?.presenter?.editBusinessCard()
        }
        return view
    }()

    /// empty footer view
    private lazy var emptyFooterView: EditCardView = {
        let view = EditCardView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.editCardViewHeight)))
        view.editButton.isHidden = false
        return view
    }()

    var presenter: ServiceDetailsPresenter?

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        presenter?.attachView(self)
        presenter?.fetchServiceDetails()
    }

    // MARK: - ServiceDetailsView

    func setupEmptyCardView() {
        tableView.tableFooterView = emptyFooterView
    }

    func setupEditCardView() {
        tableView.tableFooterView = editCardFooterView
    }

    func reload() {
        tableView.reloadData()
    }

    func set(dataSource: DataSource<ServiceDetailsDataSourceConfigurator>?) {
        dataSource?.connect(to: tableView)
    }


}

// MARK: - Privates

private extension ServiceDetailsViewController {

    func setupLayout() {
        self.navigationItem.title = "Послуга компанії"

        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
    }


}

// MARK: - UITableViewDelegate

extension ServiceDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
