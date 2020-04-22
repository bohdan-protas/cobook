//
//  AccountPresenter.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol AccountView: AlertDisplayableView, LoadDisplayableView, NavigableView {
    var tableView: UITableView! { get set }
    func setupLayout()
    func configureDataSource(with configurator: AccountDataSourceConfigurator)
    func updateDataSource(sections: [Section<Account.Item>])
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

    // MARK: Public
    func attachView(_ view: AccountView) {
        self.view = view
    }

    func detachView() {
        view = nil
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
                break
            case .statictics:
                break
            case .generateQrCode:
                break
            case .faq:
                break
            case .startMakingMoney:
                break
            case .quitAccount:
                break
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

    func fetchProfileData() {
        view?.startLoading()
        APIClient.default.profileDetails { [weak self] (result) in
            guard let strongSelf = self else { return }

            strongSelf.view?.stopLoading()
            switch result {
            case let .success(response):
                AppStorage.User.data = response
                strongSelf.personalCard = response?.cardsPreviews?
                    .filter { $0.type == CardType.personal }
                    .compactMap { CardPreviewModel(id: String($0.id),
                                                   image: $0.avatar?.sourceUrl,
                                                   firstName: AppStorage.User.data?.firstName,
                                                   lastName: AppStorage.User.data?.lastName,
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

                strongSelf.updateViewDataSource()
            case let .failure(error):
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func updateViewDataSource() {

        // header Section
        let cardHeaderSection = Section<Account.Item>(items: [
            .userInfoHeader(model: Account.UserInfoHeaderModel(avatarUrl: personalCard?.image,
                                                               firstName: AppStorage.User.data?.firstName,
                                                               lastName: AppStorage.User.data?.lastName,
                                                               telephone: AppStorage.User.data?.telephone.number,
                                                               email: AppStorage.User.data?.email.address))
        ])

        // cardsPreviews Section
        var cardsPreviewSection = Section<Account.Item>(items: [
            .sectionHeader
        ])

        if !personalCard.isNil || !businessCardsList.isEmpty {
            cardsPreviewSection.items.append(.title(text: "Мої візитки:"))
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
            cardsPreviewSection.items.append(.menuItem(model: Account.AccountMenuItemModel(title: "Створити ще одну бізнес візитку",
                                                                                           image: UIImage(named: "ic_account_createbusinescard"),
                                                                                           actiontype: .createBusinessCard)))
        } else {
            cardsPreviewSection.items.append(.menuItem(model: Account.AccountMenuItemModel(title: "Створити бізнес візитку",
                                                                                           image: UIImage(named: "ic_account_createbusinescard"),
                                                                                           actiontype: .createBusinessCard)))
        }

        // menuItems Section
        var menuItemsSection = Section<Account.Item>(items: [
            .sectionHeader,
            .menuItem(model: Account.AccountMenuItemModel(title: "Account.item.inviteFriends".localized, image: UIImage(named: "ic_account_createparsonalcard"), actiontype: .inviteFriends)),
            .menuItem(model: Account.AccountMenuItemModel(title: "Account.item.statictics".localized, image: UIImage(named: "ic_account_statistics"), actiontype: .statictics)),
            .menuItem(model: Account.AccountMenuItemModel(title: "Account.item.generateQrCode".localized, image: UIImage(named: "ic_account_qrcode"), actiontype: .generateQrCode)),
            .menuItem(model: Account.AccountMenuItemModel(title: "Account.item.faq".localized, image: UIImage(named: "ic_account_faq"), actiontype: .faq)),
        ])
        if !personalCard.isNil {
            menuItemsSection.items.append(.menuItem(model: Account.AccountMenuItemModel(title: "Account.item.startMakingMoney".localized,
                                                                                        image: UIImage(named: "ic_account_startmakingmoney"),
                                                                                        actiontype: .startMakingMoney)))
        }

        // Quit account section
        let quitAccountSectin = Section<Account.Item>(items: [
            .sectionHeader,
            .menuItem(model: Account.AccountMenuItemModel(title: "Account.item.quitAccount".localized, image: UIImage(named: "ic_account_logout"), actiontype: .quitAccount)),
        ])

        sections = [cardHeaderSection, cardsPreviewSection, menuItemsSection, quitAccountSectin]
    }




}
