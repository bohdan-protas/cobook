//
//  PersonalCardDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 3/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol PersonalCardDetailsView: AlertDisplayableView, LoadDisplayableView, NavigableView {
    var tableView: UITableView! { get set }
}

class PersonalCardDetailsPresenter: NSObject, BasePresenter {

    // MARK: Properties
    private weak var view: PersonalCardDetailsView?
    private var personalCardId: Int

    // MARK: Lifecycle
    init(id: Int) {
        self.personalCardId = id
    }

    // MARK: Public
    func attachView(_ view: PersonalCardDetailsView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    func onViewDidLoad() {
        Log.debug("Presenter loaded with id: \(personalCardId)")
    }

}
