//
//  PersonalCardDetailsViewController.swift
//  CoBook
//
//  Created by protas on 3/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class PersonalCardDetailsViewController: BaseViewController, PersonalCardDetailsView {

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!

    // MARK: Properties
    var presenter: PersonalCardDetailsPresenter?

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
