//
//  BusinessCardDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 4/6/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol BusinessCardDetailsView: AlertDisplayableView, LoadDisplayableView, NavigableView {
    func configureDataSource(with configurator: BusinessCardDetailsDataSourceConfigurator)
    func updateDataSource(sections: [Section<BusinessCardDetails.Cell>])

    func sendEmail(to address: String)
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
        self.view?.configureDataSource(with: self.dataSourceConfigurator)
        fetchDetails { model in
            self.cardDetails = model

            self.updateViewDataSource()
        }
    }

    func onViewWillAppear() {

    }


}

// MARK: -
private extension BusinessCardDetailsPresenter {

    func updateViewDataSource() {
        let userInfoSection = Section<BusinessCardDetails.Cell>(items: [
            .userInfo(model: BusinessCardDetails.HeaderInfoModel(name: cardDetails?.company.name,
                                                                 avatartImagePath: cardDetails?.avatar?.sourceUrl,
                                                                 bgimagePath: cardDetails?.background?.sourceUrl,
                                                                 profession: cardDetails?.practiceType?.title,
                                                                 telephoneNumber: cardDetails?.contactTelephone?.number,
                                                                 websiteAddress: cardDetails?.companyWebSite)),

            .companyDescription(text: cardDetails?.description),
            .addressInfo(model: AddressInfoCellModel(mainAddress: cardDetails?.region?.name, subAdress: cardDetails?.city?.name, schedule: cardDetails?.schedule)),
            .map(path: ""),
            .mapDirection
        ])

        var getInTouchSection = Section<BusinessCardDetails.Cell>(items: [
        ])

        let listListItems = (cardDetails?.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
        if !listListItems.isEmpty {
            getInTouchSection.items.append(.socialList)
        }
        getInTouchSection.items.append(.getInTouch)

        view?.updateDataSource(sections: [userInfoSection, getInTouchSection])
    }


}

// MARK: - Use cases
private extension BusinessCardDetailsPresenter {

    func fetchDetails(onSuccess: ((CardDetailsApiModel?) -> Void)?) {
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

// MARK: - SocialsListTableViewCellDataSource
extension BusinessCardDetailsPresenter: SocialsListTableViewCellDataSource {

    var socials: [Social.ListItem] {
        get {
            let listListItems = (cardDetails?.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
            return listListItems
        }
        set {}
    }


}

// MARK: - SocialsListTableViewCellDelegate
extension BusinessCardDetailsPresenter: SocialsListTableViewCellDelegate {

    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didSelectedSocialItem item: Social.ListItem) {
        switch item {
        case .view(let model):
            if let url = model.url, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                view?.errorAlert(message: "Посилання соцмережі має нечитабельний формат")
            }
        default:
            break
        }
    }

    func socialsListTableViewCell(_ cell: SocialsListTableViewCell, didLongPresseddOnItem value: Social.Model, at indexPath: IndexPath) {
    }


}

// MARK: - GetInTouchTableViewCellDelegate
extension BusinessCardDetailsPresenter: GetInTouchTableViewCellDelegate {

    func getInTouchTableViewCellDidOccuredCallAction(_ cell: GetInTouchTableViewCell) {
        guard let number = cardDetails?.contactTelephone?.number, let numberUrl = URL(string: "tel://" + number) else {
            view?.errorAlert(message: "Telephone number of user have bad format")
            return
        }
        UIApplication.shared.open(numberUrl, options: [:], completionHandler: nil)
    }

    func getInTouchTableViewCellDidOccuredEmailAction(_ cell: GetInTouchTableViewCell) {
        view?.sendEmail(to: cardDetails?.contactEmail?.address ?? "")
    }


}
