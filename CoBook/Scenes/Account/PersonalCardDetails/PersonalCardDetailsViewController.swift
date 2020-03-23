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
        static let sectionHeaderHeight: CGFloat = 28
    }

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!

    // MARK: Properties
    var presenter: PersonalCardDetailsPresenter?
    private lazy var editCardView: EditCardView = {
        let view = EditCardView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.footerHeight)))
        view.onEditTapped = { [weak self] in
            self?.presenter?.editPerconalCard()
        }
        return view
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        presenter?.attachView(self)
        presenter?.onViewDidLoad()
    }

    deinit {
        presenter?.detachView()
    }

    // MARK: - PersonalCardDetailsView
    func setupHeaderFooterViews() {
        tableView.tableFooterView = editCardView
    }

    func sendEmail(to address: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["you@yoursite.com"])
            present(mail, animated: true)
        } else {
            errorAlert(message: "Unaviable send email to this address")
        }
    }


}

// MARK: Privates
private extension PersonalCardDetailsViewController {

    func setupLayout() {
        navigationItem.title = "Персональна візитка"
        tableView.delegate = self
    }


}

// MARK: - UITableViewDelegate
extension PersonalCardDetailsViewController: UITableViewDelegate {

}

// MARK: - MFMailComposeViewControllerDelegate
extension PersonalCardDetailsViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }


}
