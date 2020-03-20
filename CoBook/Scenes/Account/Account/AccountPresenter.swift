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
    func fillHeader(with profile: Profile?)
}

class AccountPresenter: BasePresenter {
    // MARK: Properties
    private weak var view: AccountView?
    var dataSource: AccountDataSource?

    private var personalCardsList: [CardPreview] = []

    // MARK: Public
    func attachView(_ view: AccountView) {
        self.view = view
        self.dataSource = AccountDataSource(tableView: view.tableView)
    }

    func detachView() {
        view = nil
        dataSource = nil
    }

    func onDidAppear() {
        fetchProfileData()
    }

    func selectedRow(at indexPath: IndexPath) {
        guard let actionType = dataSource?.source[safe: indexPath.section]?.items[safe: indexPath.item] else {
            debugPrint("Error occured when selected account action type")
            return
        }

        switch actionType {
        case .action(let type):
            switch type {
            case .createPersonalCard:
                let createPersonalCardController: CreatePersonalCardViewController = UIStoryboard.account.initiateViewControllerFromType()
                view?.push(controller: createPersonalCardController, animated: true)
            case .createBusinessCard:
                break
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

        case .businessCardPreview(let model):
            break
        case .personalCardPreview(let model):
            break

        default: break
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
                AppStorage.User.profile = response
                strongSelf.personalCardsList = response?.personalCardsList ?? []
                strongSelf.setupDataSource()
            case let .failure(error):
                strongSelf.personalCardsList = AppStorage.User.profile?.personalCardsList ?? []
                strongSelf.setupDataSource()
                strongSelf.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func setupDataSource() {
        view?.fillHeader(with: AppStorage.User.profile)

        var cardsPreviceSection = Account.Section(items: [])
        if personalCardsList.isEmpty {
            cardsPreviceSection.items = [
                .action(type: .createPersonalCard),
                .action(type: .createBusinessCard),
            ]
        } else {
            cardsPreviceSection.items.append(.title(text: "Мої візитки:"))
            personalCardsList.forEach {
                cardsPreviceSection.items.append(.personalCardPreview(model: Account.CardPreview(id: $0.id,
                                                                                                 image: $0.avatar?.sourceUrl,
                                                                                                 name: "\(AppStorage.User.profile?.firstName ?? "") \(AppStorage.User.profile?.lastName ?? "")",
                                                                                                 profession: $0.practiceType?.title,
                                                                                                 telephone: $0.telephone?.number)))
                cardsPreviceSection.items.append(.action(type: .createBusinessCard))
            }
        }

        // Setup data source
        dataSource?.source = [
            cardsPreviceSection,
            Account.Section(items: [
                .action(type: .inviteFriends),
                .action(type: .statictics),
                .action(type: .generateQrCode),
                .action(type: .faq)
            ]),

            Account.Section(items: [
                .action(type: .quitAccount),
            ])
        ]

        dataSource?.tableView.reloadData()
    }




}
