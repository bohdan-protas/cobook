//
//  CreatePersonalCardViewController.swift
//  CoBook
//
//  Created by protas on 3/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CreatePersonalCardViewController: UIViewController, CreatePersonalCardView {

    // MARK: Properties
    var presenter = CreatePersonalCardPresenter()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.attachView(self)
        setupLayout()
    }

    // MARK: Public
    func startLoading() { }

    func stopLoading() { }


}

// MARK: Privates
private extension CreatePersonalCardViewController {

    func setupLayout() {
        self.navigationItem.title = "Create Personal Card"
    }


}
