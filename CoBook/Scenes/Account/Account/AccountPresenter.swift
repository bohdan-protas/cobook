//
//  AccountPresenter.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol AccountView: AlertDisplayableView, LoadDisplayableView {
    func fillHeader(with profile: Profile?)
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
    

    func attachView(_ view: AccountView) { self.view = view }
    func detachView() { view = nil }

}
