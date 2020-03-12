//
//  CreatePersonalCardViewController.swift
//  CoBook
//
//  Created by protas on 3/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CreatePersonalCardViewController: UIViewController, CreatePersonalCardView {

    enum Defaults {
        static let estimatedRowHeight: CGFloat = 44
        static let headerHeight: CGFloat = 120
        static let footerHeight: CGFloat = 124
        static let sectionHeaderHeight: CGFloat = 28
    }

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!

    // MARK: Properties
    var presenter = CreatePersonalCardPresenter()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        presenter.attachView(self)
        presenter.setup()
    }

    // MARK: Public
    func startLoading() { }

    func stopLoading() { }


}

// MARK: Privates
private extension CreatePersonalCardViewController {

    func setupLayout() {
        self.navigationItem.title = "Create Personal Card"

        tableView.delegate = self
        tableView.tableHeaderView = PersonalCardPhotoManagmentView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: Defaults.headerHeight)))
        tableView.tableFooterView = CardSaveView(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.size.width, height: Defaults.footerHeight)))
    }


}

// MARK: - UITableViewDelegate
extension CreatePersonalCardViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return SectionHeaderSeparatorView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Defaults.sectionHeaderHeight
    }


}
