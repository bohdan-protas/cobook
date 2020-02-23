//
//  SignInPresenter.swift
//  CoBook
//
//  Created by protas on 2/21/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

protocol SignInView: BaseView {
    var presenter: SignInPresenter { get set }
}

class SignInPresenter: BasePresenter {
    private weak var view: SignInView?

    var login: String?
    var password: String?

    func attachView(_ view: SignInView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    func set(login: String?, password: String?) {
        self.login = login
        self.password = password
    }
}
