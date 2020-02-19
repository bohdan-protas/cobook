//
//  SignUpPresenter.swift
//  CoBook
//
//  Created by protas on 2/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: View -
protocol SignUpViewProtocol: class {

}

// MARK: Presenter -
protocol SignUpPresenterProtocol: class {
	var view: SignUpViewProtocol? { get set }
    func signUp()
    func checkFields(name: String?, telephone: String?, email: String?) -> Bool
}

class SignUpPresenter: SignUpPresenterProtocol {
    weak var view: SignUpViewProtocol?

    var name: String = ""
    var telephone: String = ""
    var email: String = ""

    func signUp() {
        // TODO call to server
    }

    func checkFields(name: String?, telephone: String?, email: String?) -> Bool {
        self.name = name ?? ""
        self.telephone = telephone ?? ""
        self.email = email ?? ""

        return
            !self.name.isEmpty &&
            !self.telephone.isEmpty &&
            RegularExpression(pattern: .email).match(in: self.email)
    }
}
