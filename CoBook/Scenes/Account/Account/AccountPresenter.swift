//
//  AccountPresenter.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol AccountView: AlertDisplayableView, LoadDisplayableView {

}

class AccountPresenter: BasePresenter {
    weak var view: AccountView?
    var dataSource = AccountDataSource()

    func setup() {
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
    }

    func attachView(_ view: AccountView) { self.view = view }
    func detachView() { view = nil }

}
