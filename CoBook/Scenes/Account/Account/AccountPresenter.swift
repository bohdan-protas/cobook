//
//  AccountPresenter.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol AccountView: AlertDisplayableView, LoadDisplayableView {
    func fillHeader(with profile: Profile?)

    func push(controller: UIViewController)
}

class AccountPresenter: BasePresenter {
    weak var view: AccountView?
    var dataSource = AccountDataSource()

    func setup() {
        // Setup data source
        dataSource.sections = [

            Account.Section(items: [
                Account.Item.action(type: .createBusinessCard),
                Account.Item.action(type: .createPersonalCard),
            ]),

            Account.Section(items: [
                Account.Item.action(type: .inviteFriends),
                Account.Item.action(type: .statictics),
                Account.Item.action(type: .generateQrCode),
                Account.Item.action(type: .faq)
            ]),

            Account.Section(items: [
                Account.Item.action(type: .quitAccount),
            ])
        ]

        //setup header
        view?.fillHeader(with: AppStorage.profile)
    }

    func selectedRow(at indexPath: IndexPath) {
        guard let actionType = dataSource.sections[safe: indexPath.section]?.items[safe: indexPath.item] else {
            debugPrint("Error occured when selected account action type")
            return
        }

        switch actionType {

        case .action(let type):

            switch type {
            case .createPersonalCard:
                let createPersonalCardController: CreatePersonalCardViewController = UIStoryboard.account.initiateViewControllerFromType()
                view?.push(controller: createPersonalCardController)
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

        case .businessCard(let model):
            break
        }


    }

    func attachView(_ view: AccountView) { self.view = view }
    func detachView() { view = nil }

}
