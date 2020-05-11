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

    /// Managed view
    weak var view: SignUpView?

    private var firstName: String = ""
    private var lastName: String = ""
    private var telephone: String = ""
    private var email: String = ""

    // MARK: - Public

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
                AppStorage.User.isUserInitiatedRegistration = true
                AppStorage.User.Profile?.telephone.number = self.telephone
                AppStorage.User.Profile?.email.address = self.email

                AppStorage.Auth.accessToken = response?.accessToken

                self.view?.goToConfirmTelephoneNumber()
            case .failure(let error):
                self.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }

    func set(firstName: String?,lastName: String?, telephone: String?, email: String?) {
        self.firstName = firstName ?? ""
        self.lastName = lastName ?? ""
        self.telephone = telephone ?? ""
        self.email = email ?? ""

        let actived = !self.firstName.isEmpty && !self.lastName.isEmpty && !self.telephone.isEmpty && !self.email.isEmpty
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
