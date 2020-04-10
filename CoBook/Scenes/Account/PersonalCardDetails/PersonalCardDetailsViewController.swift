//
//  PersonalCardDetailsViewController.swift
//  CoBook
//
//  Created by protas on 3/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import MessageUI

class PersonalCardDetailsViewController: BaseViewController, PersonalCardDetailsView {

    enum Defaults {
        static let estimatedRowHeight: CGFloat = 44
        static let footerHeight: CGFloat = 84
    }

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!

    // MARK: Properties
    var presenter: PersonalCardDetailsPresenter?
    var dataSource: TableDataSource<PersonalCardDetailsDataSourceConfigurator>?

    private lazy var editCardView: EditCardView = {
        let view = EditCardView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.footerHeight)))
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

    func sendEmail(to address: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([address])
            present(mail, animated: true)
        } else {
            errorAlert(message: "Unaviable send email to \(address)")
        }
    }

    func configureDataSource(with configurator: PersonalCardDetailsDataSourceConfigurator) {
        dataSource = TableDataSource(tableView: self.tableView, configurator: configurator)
        tableView.dataSource = dataSource
    }

    func updateDataSource(sections: [Section<PersonalCardDetails.Cell>]) {
        dataSource?.sections = sections
        tableView.setContentOffset(.zero, animated: false)
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

// MARK: - MFMailComposeViewControllerDelegate

extension PersonalCardDetailsViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }


}
