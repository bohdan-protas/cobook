//
//  BusinessCardDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol BusinessCardDetailsView: AlertDisplayableView, LoadDisplayableView, NavigableView {
    func setupLayout()
    func configureDataSource(with configurator: BusinessCardDetailsDataSourceConfigurator)
    func updateDataSource(sections: [Section<BusinessCardDetails.Cell>])
}

class BusinessCardDetailsPresenter: NSObject, BasePresenter {

    // MARK: Properties
    private weak var view: BusinessCardDetailsView?
    private lazy var dataSourceConfigurator: BusinessCardDetailsDataSourceConfigurator = {
        let dataSourceConfigurator = BusinessCardDetailsDataSourceConfigurator(presenter: self)
        return dataSourceConfigurator
    }()

    private var businessCardId: Int
    private var cardDetails: CardDetailsApiModel?

    // MARK: Lifecycle
    init(id: Int) {
        self.businessCardId = id
    }

    // MARK: Public
    func attachView(_ view: BusinessCardDetailsView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    func onViewDidLoad() {
        
    }

    func onViewWillAppear() {

    }


}

// MARK: Use cases
private extension BusinessCardDetailsPresenter {

    func setupDataSource(onSuccess: ((CardDetailsApiModel?) -> Void)?) {
        view?.startLoading()
        APIClient.default.getCardInfo(id: businessCardId) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            self?.view?.stopLoading()

            switch result {
            case let .success(response):
                onSuccess?(response)
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

}
