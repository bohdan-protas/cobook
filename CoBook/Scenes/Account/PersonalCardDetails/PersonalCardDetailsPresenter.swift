//
//  PersonalCardDetailsPresenter.swift
//  CoBook
//
//  Created by protas on 3/22/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol PersonalCardDetailsView: AlertDisplayableView, LoadDisplayableView, NavigableView, MessagingCallingView {
    func setupLayout()
    func set(dataSource: DataSource<PersonalCardDetailsDataSourceConfigurator>?)
    func reload()
    func setupEditView()
    func setupEmptyBottomView()
}

class PersonalCardDetailsPresenter: NSObject, BasePresenter {

    /// managed veiw
    private weak var view: PersonalCardDetailsView?

    private var personalCardId: Int
    private var cardDetails: CardDetailsApiModel?
    private var dataSource: DataSource<PersonalCardDetailsDataSourceConfigurator>?

    /// Flag for owner identifire
    private var isUserOwner: Bool {
        return AppStorage.User.Profile?.userId == cardDetails?.cardCreator?.id
    }

    // MARK: - Lifecycle

    init(id: Int) {
        self.personalCardId = id
        super.init()
        self.dataSource = DataSource(configurator: self.dataSourceConfigurator)
    }

    // MARK: - Public

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
                strongSelf.view?.set(dataSource: strongSelf.dataSource)
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
            .userInfo(model: cardDetails),
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

        isUserOwner ? view?.setupEditView() : view?.setupEmptyBottomView()

        dataSource?.sections = [ userInfoSection, getInTouchSection ]
        view?.reload()
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
        view?.makeCall(to: cardDetails?.contactTelephone?.number)
    }

    func getInTouchTableViewCellDidOccuredEmailAction(_ cell: GetInTouchTableViewCell) {
        view?.sendEmail(to: cardDetails?.contactEmail?.address ?? "")
    }


}

// MARK: - PersonalCardUserInfoTableViewCellDelegate

extension PersonalCardDetailsPresenter: PersonalCardUserInfoTableViewCellDelegate {

    func onSaveCard(cell: PersonalCardUserInfoTableViewCell) {
        let state = cardDetails?.isSaved ?? false

        switch state {
        case false:
            view?.startLoading()
            APIClient.default.addCardToFavourites(id: personalCardId) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success:
                    cell.saveButton.isSelected = true
                    self?.cardDetails?.isSaved = true
                    NotificationCenter.default.post(name: .cardSaved, object: nil, userInfo: [Notification.Key.cardID: strongSelf.personalCardId, Notification.Key.controllerID: BusinessCardDetailsViewController.describing])
                    self?.view?.stopLoading(success: true, succesText: "Збережено", failureText: nil, completion: nil)
                case .failure:
                    self?.view?.stopLoading(success: false)
                }
            }

        case true:
            view?.startLoading()
            APIClient.default.deleteCardFromFavourites(id: personalCardId) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success:
                    cell.saveButton.isSelected = false
                    self?.cardDetails?.isSaved = false
                    NotificationCenter.default.post(name: .cardUnsaved, object: nil, userInfo: [Notification.Key.cardID: strongSelf.personalCardId, Notification.Key.controllerID: BusinessCardDetailsViewController.describing])
                    self?.view?.stopLoading(success: true, succesText: "Вилучено із збережених", failureText: nil, completion: nil)
                case .failure:
                    self?.view?.stopLoading(success: false)
                }
            }
        }

    }


}
