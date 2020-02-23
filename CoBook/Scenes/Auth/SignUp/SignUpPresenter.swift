//
//  SignUpPresenter.swift
//  CoBook
//
//  Created by protas on 2/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: View -
protocol SignUpViewProtocol: BaseView {
    func setContinueButton(actived: Bool)
}

class SignUpPresenter: BasePresenter {
    weak var view: SignUpViewProtocol?

    // MARK: Properties
    var name: String = ""
    var telephone: String = ""
    var email: String = ""

    // MARK: Public
    func attachView(_ view: SignUpViewProtocol) {
        self.view = view
    }

    func detachView() {
        self.view = nil
    }

    func signUp() {
        // TODO call to server
    }

    func set(name: String?, telephone: String?, email: String?) {
        self.name = name ?? ""
        self.telephone = telephone ?? ""
        self.email = email ?? ""

        let actived = !self.name.isEmpty && !self.telephone.isEmpty && !self.email.isEmpty
        view?.setContinueButton(actived: actived)
    }
}
