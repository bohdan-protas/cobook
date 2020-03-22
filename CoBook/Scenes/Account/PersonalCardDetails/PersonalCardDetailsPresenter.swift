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
        view?.startLoading()
        APIClient.default.getCardInfo(id: personalCardId) { [weak self] (result) in
            self?.view?.stopLoading()

            switch result {
            case let .success(response):
                self?.view?.infoAlert(title: nil, message: "Received success!")
            case let .failure(error):
                self?.view?.errorAlert(message: error.localizedDescription, handler: { (_) in
                    self?.view?.popController()
                })
                Log.error(error.localizedDescription)
            }
        }
    }

}
