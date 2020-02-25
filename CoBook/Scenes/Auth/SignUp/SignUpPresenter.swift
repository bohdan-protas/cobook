//
//  SignUpPresenter.swift
//  CoBook
//
//  Created by protas on 2/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: SignUpView
protocol SignUpView: LoadDisplayableView, AlertDisplayableView {
    func setContinueButton(actived: Bool)
    func goToConfirmTelephoneNumber()
}

class SignUpPresenter: BasePresenter {
    weak var view: SignUpView?

    // MARK: Properties
    private var firstName: String = ""
    private var lastName: String = ""
    private var telephone: String = ""
    private var email: String = ""

    // MARK: Public
    func attachView(_ view: SignUpView) {
        self.view = view
    }

    func detachView() {
        self.view = nil
    }

    func signUp() {
        if let validationErrorDescription = validateFields() {
            view?.infoAlert(title: nil, message: validationErrorDescription)
            return
        }

        view?.startLoading()
        APIClient.default.signUpInitializationRequest(email: email, telephone: telephone, firstName: firstName, lastName: lastName) { (result) in
            self.view?.stopLoading()

            switch result {
            case .success(let response):
                switch response.status {
                case .ok:
                    UserDataManager.default.accessToken = response.data?.accessToken
                    UserDataManager.default.telephone = self.telephone
                    self.view?.goToConfirmTelephoneNumber()
                case .error:
                    self.view?.infoAlert(title: nil, message: response.errorDescription)
                    debugPrint(response.errorDescription ?? "")
                }

            case .failure(let error):
                self.view?.defaultErrorAlert()
                debugPrint(error.localizedDescription)
            }
        }
    }

    func set(fullName: String?, telephone: String?, email: String?) {
        self.firstName = (fullName ?? "").components(separatedBy: " ")[safe: 0] ?? ""
        self.lastName = (fullName ?? "").components(separatedBy: " ")[safe: 1] ?? ""

        self.telephone = telephone ?? ""
        self.email = email ?? ""

        let actived = !self.firstName.isEmpty && !lastName.isEmpty && !self.telephone.isEmpty && !self.email.isEmpty
        view?.setContinueButton(actived: actived)
    }


}

// MARK: - Privates
private extension SignUpPresenter {

    func validateFields() -> String? {
        if let error = ValidationManager.validate(firstName: firstName) {
            return error
        }

        if let error = ValidationManager.validate(lastName: lastName) {
            return error
        }

        if let error = ValidationManager.validate(telephone: telephone) {
            return error
        }

        if let error = ValidationManager.validate(email: email) {
            return error
        }

        return nil
    }

}
