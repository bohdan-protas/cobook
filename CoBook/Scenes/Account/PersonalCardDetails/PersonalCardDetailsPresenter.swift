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
    func setupLayout()
    func sendEmail(to address: String)

    func configureDataSource(with configurator: PersonalCardDetailsDataSourceConfigurator)
    func updateDataSource(sections: [Section<PersonalCardDetails.Cell>])
}

class PersonalCardDetailsPresenter: NSObject, BasePresenter {

    private weak var view: PersonalCardDetailsView?
    private lazy var dataSourceConfigurator: PersonalCardDetailsDataSourceConfigurator = {
        let dataSourceConfigurator = PersonalCardDetailsDataSourceConfigurator(presenter: self)
        return dataSourceConfigurator
    }()

    private var personalCardId: Int
    private var cardDetails: CardDetailsApiModel?

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

    func setupDataSource() {
        view?.startLoading()
        APIClient.default.getCardInfo(id: personalCardId) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            self?.view?.stopLoading()

            switch result {
            case let .success(response):
                strongSelf.cardDetails = response
                strongSelf.view?.setupLayout()
                strongSelf.view?.configureDataSource(with: strongSelf.dataSourceConfigurator)
                strongSelf.updateViewDataSource()
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func editPerconalCard() {
        let createPersonalCardViewController: CreatePersonalCardViewController = UIStoryboard.account.initiateViewControllerFromType()
        if let cardDetails = cardDetails {
            let presenter = CreatePersonalCardPresenter(detailsModel: CreatePersonalCard.DetailsModel(apiModel: cardDetails))
            createPersonalCardViewController.presenter = presenter
        } else {
            let presenter = CreatePersonalCardPresenter()
            createPersonalCardViewController.presenter = presenter
        }
        view?.push(controller: createPersonalCardViewController, animated: true)
    }
    

}

// MARK: - PersonalCardDetailsPresenter

private extension PersonalCardDetailsPresenter {

    func updateViewDataSource() {
        let userInfoSection = Section<PersonalCardDetails.Cell>(items: [
            .userInfo(model: cardDetails)
        ])

        var getInTouchSection = Section<PersonalCardDetails.Cell>(items: [
            .sectionHeader,
            .title(text: "Зв’язатись:")
        ])

        let listListItems = (cardDetails?.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
        if !listListItems.isEmpty {
            getInTouchSection.items.append(.socialList)
        }
        getInTouchSection.items.append(.getInTouch)


        view?.updateDataSource(sections: [userInfoSection, getInTouchSection])
    }


}

// MARK: - SocialsListTableViewCellDataSource

extension PersonalCardDetailsPresenter: SocialsListTableViewCellDataSource {

    var socials: [Social.ListItem] {
        get {
            let listListItems = (cardDetails?.socialNetworks ?? []).compactMap { Social.ListItem.view(model: Social.Model(title: $0.title, url: $0.link)) }
            return listListItems
        }
        set {}
    }


}

// MARK: - SocialsListTableViewCellDelegate

extension PersonalCardDetailsPresenter: SocialsListTableViewCellDelegate {

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

extension PersonalCardDetailsPresenter: GetInTouchTableViewCellDelegate {

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
