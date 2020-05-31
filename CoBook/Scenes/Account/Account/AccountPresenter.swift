//
//  AccountPresenter.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

protocol AccountView: AlertDisplayableView, LoadDisplayableView, NavigableView, ShareableView {
    func setupLayout()
    func configureDataSource(with configurator: AccountDataSourceConfigurator)
    func updateDataSource(sections: [Section<Account.Item>])
    func stopRefreshing()
}

class AccountPresenter: BasePresenter {

    // MARK: Properties

    private weak var view: AccountView?
    private lazy var dataSourceConfigurator: AccountDataSourceConfigurator = {
        let dataSourceConfigurator = AccountDataSourceConfigurator(presenter: self)
        return dataSourceConfigurator
    }()

    private var personalCard: CardPreviewModel?
    private var businessCardsList = [CardPreviewModel]()

    private var sections: [Section<Account.Item>] = [] {
        didSet {
            view?.updateDataSource(sections: sections)
        }
    }

    private var isRefreshing: Bool = false

    // MARK: - Public

    func attachView(_ view: AccountView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    func refresh() {
        isRefreshing = true
        fetchProfileData()
    }

    func onViewDidLoad() {
        view?.setupLayout()
        view?.configureDataSource(with: dataSourceConfigurator)

        AppStorage.State.isNeedToUpdateAccountData = false
        fetchProfileData()
    }

    func onDidAppear() {
        if AppStorage.State.isNeedToUpdateAccountData {
            fetchProfileData()
            AppStorage.State.isNeedToUpdateAccountData = false
        }
    }

    func selectedRow(at indexPath: IndexPath) {
        guard let item = sections[safe: indexPath.section]?.items[safe: indexPath.item] else {
            debugPrint("Error occured when selected account action type")
            return
        }

        switch item {
        case .menuItem(let model):
            switch model.actiontype {
            case .createPersonalCard:
                let createPersonalCardController: CreatePersonalCardViewController = UIStoryboard.account.initiateViewControllerFromType()
                view?.push(controller: createPersonalCardController, animated: true)

            case .createBusinessCard:
                let createBusinessCardController: CreateBusinessCardViewController = UIStoryboard.account.initiateViewControllerFromType()
                view?.push(controller: createBusinessCardController, animated: true)

            case .inviteFriends:
                inviteFriends()

            case .statictics: break
            case .generateQrCode: break
            case .faq: break
            case .startMakingMoney: break
            case .quitAccount:
                logout()
            }

        case .personalCardPreview(let model):
            let personalCardDetailsViewController: PersonalCardDetailsViewController = UIStoryboard.account.initiateViewControllerFromType()
            if let strid = model.id, let id = Int(strid) {
                personalCardDetailsViewController.presenter = PersonalCardDetailsPresenter(id: id)
            }
            view?.push(controller: personalCardDetailsViewController, animated: true)

        case .businessCardPreview(let model):
            let businessCardDetailsViewController: BusinessCardDetailsViewController = UIStoryboard.account.initiateViewControllerFromType()
            if let strid = model.id, let id = Int(strid) {
                businessCardDetailsViewController.presenter = BusinessCardDetailsPresenter(id: id)
            }
            view?.push(controller: businessCardDetailsViewController, animated: true)

        default:
            break
        }

    }


}

// MARK: - Privates

private extension AccountPresenter {

    func inviteFriends() {
        let socialMetaTags = DynamicLinkSocialMetaTagParameters()
        socialMetaTags.imageURL = APIConstants.cobookLogoURL
        socialMetaTags.title = "Social.metaTag.inviteFriends.title".localized
        socialMetaTags.descriptionText = "Social.metaTag.inviteFriends.description".localized
        view?.showShareSheet(path: .download, parameters: [:], dynamicLinkSocialMetaTagParameters: socialMetaTags)
    }

    func logout() {
        view?.startLoading()
        APIClient.default.logout { [weak self] (result) in
            switch result {
            case .success:
                AppStorage.Auth.deleteAllData()
                let signInNavigationController: SignInNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
                if let topController = UIApplication.topViewController() {
                    topController.present(signInNavigationController, animated: true, completion: nil)
                }
            case .failure(let error):
                self?.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func fetchProfileData() {
        if !isRefreshing { view?.startLoading() }
        APIClient.default.profileDetails { [weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.isRefreshing = false
            strongSelf.view?.stopLoading()
            switch result {
            case let .success(response):
                AppStorage.User.Profile = response
                strongSelf.personalCard = response?.cardsPreviews?
                    .filter { $0.type == CardType.personal }
                    .compactMap { CardPreviewModel(id: String($0.id),
                                                   image: $0.avatar?.sourceUrl,
                                                   firstName: AppStorage.User.Profile?.firstName,
                                                   lastName: AppStorage.User.Profile?.lastName,
                                                   profession: $0.practiceType?.title,
                                                   telephone: $0.telephone?.number) }.first

                strongSelf.businessCardsList = response?.cardsPreviews?
                    .filter { $0.type == CardType.business }
                    .compactMap { CardPreviewModel(id: String($0.id),
                                                   image: $0.avatar?.sourceUrl,
                                                   firstName: $0.company?.name,
                                                   lastName: nil,
                                                   profession: $0.practiceType?.title,
                                                   telephone: $0.telephone?.number) } ?? []

                strongSelf.view?.stopRefreshing()
                strongSelf.updateViewDataSource()

            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func updateViewDataSource() {

        // header Section
        let cardHeaderSection = Section<Account.Item>(items: [
            .userInfoHeader(model: Account.UserInfoHeaderModel(avatarUrl: AppStorage.User.Profile?.avatar?.sourceUrl,
                                                               firstName: AppStorage.User.Profile?.firstName,
                                                               lastName: AppStorage.User.Profile?.lastName,
                                                               telephone: AppStorage.User.Profile?.telephone.number,
                                                               email: AppStorage.User.Profile?.email.address))
        ])

        // cardsPreviews Section
        var cardsPreviewSection = Section<Account.Item>(items: [
            .sectionHeader
        ])

        if !personalCard.isNil || !businessCardsList.isEmpty {
            cardsPreviewSection.items.append(.title(text: "Account.section.myCards.title".localized))
        }

        if let personalCard = personalCard {
            cardsPreviewSection.items.append(.personalCardPreview(model: personalCard))
        } else {
            cardsPreviewSection.items.append(.menuItem(model: Account.AccountMenuItemModel(title: "Account.item.createPersonalCard".localized,
                                                                                               image: UIImage(named: "ic_account_createparsonalcard"),
                                                                                               actiontype: .createPersonalCard)))
        }

        if !businessCardsList.isEmpty {
            let cards: [Account.Item] = businessCardsList.map { Account.Item.businessCardPreview(model: $0) }
            cardsPreviewSection.items.append(contentsOf: cards)
            cardsPreviewSection.items.append(.menuItem(model: Account.AccountMenuItemModel(title: "Account.item.createAnotherOneBusinessCard".localized,
                                                                                           image: UIImage(named: "ic_account_createbusinescard"),
                                                                                           actiontype: .createBusinessCard)))
        } else {
            cardsPreviewSection.items.append(.menuItem(model: Account.AccountMenuItemModel(title: "Account.item.createBusinessCard".localized,
                                                                                           image: UIImage(named: "ic_account_createbusinescard"),
                                                                                           actiontype: .createBusinessCard)))
        }

        // menuItems Section
        let menuItemsSection = Section<Account.Item>(items: [
            .sectionHeader,
            .menuItem(model: Account.AccountMenuItemModel(title: "Account.item.inviteFriends".localized, image: UIImage(named: "ic_account_createparsonalcard"), actiontype: .inviteFriends)),
            //.menuItem(model: Account.AccountMenuItemModel(title: "Account.item.statictics".localized, image: UIImage(named: "ic_account_statistics"), actiontype: .statictics)),
            //.menuItem(model: Account.AccountMenuItemModel(title: "Account.item.generateQrCode".localized, image: UIImage(named: "ic_account_qrcode"), actiontype: .generateQrCode)),
            .menuItem(model: Account.AccountMenuItemModel(title: "Account.item.faq".localized, image: UIImage(named: "ic_account_faq"), actiontype: .faq)),
        ])
//        if !personalCard.isNil {
//            menuItemsSection.items.append(.menuItem(model: Account.AccountMenuItemModel(title: "Account.item.startMakingMoney".localized,
//                                                                                        image: UIImage(named: "ic_account_startmakingmoney"),
//                                                                                        actiontype: .startMakingMoney)))
//        }

        // Quit account section
        let quitAccountSectin = Section<Account.Item>(items: [
            .sectionHeader,
            .menuItem(model: Account.AccountMenuItemModel(title: "Account.item.quitAccount".localized, image: UIImage(named: "ic_account_logout"), actiontype: .quitAccount)),
        ])

        sections = [cardHeaderSection, cardsPreviewSection, menuItemsSection, quitAccountSectin]
    }


}

// MARK: - AccountHeaderTableViewCellDelegate

extension AccountPresenter: AccountHeaderTableViewCellDelegate {

    func settingTapped(cell: AccountHeaderTableViewCell) {
        let settingsController: SettingsTableViewController = UIStoryboard.account.initiateViewControllerFromType()
        view?.push(controller: settingsController, animated: true)
    }


}
