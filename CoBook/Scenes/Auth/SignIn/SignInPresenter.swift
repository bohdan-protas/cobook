//
//  SignInPresenter.swift
//  CoBook
//
//  Created by protas on 2/21/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

// MARK: - SignInView
protocol SignInView: class, LoadDisplayableView, AlertDisplayableView {
    var presenter: SignInPresenter { get set }
    func setSignInButton(enabled: Bool)
    func goToMainTabbar()
}

// MARK: - SignInPresenter
class SignInPresenter: BasePresenter {

    private weak var view: SignInView?

    private var login: String = ""
    private var password: String = ""

    func attachView(_ view: SignInView) {
        self.view = view
    }

    func detachView() {
        view = nil
    }

    // MARK: - Public
    func set(login: String?, password: String?) {
        self.login = login ?? ""
        self.password = password ?? ""

        let isEnabled = !self.login.isEmpty && !self.password.isEmpty
        view?.setSignInButton(enabled: isEnabled)
    }

    func signIn() {
        if let validationErrorDescription = validateFields() {
            view?.infoAlert(title: nil, message: validationErrorDescription)
            return
        }
        
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        if deviceID == nil {
            Log.error("device ID is not defined!")
        }
        
        view?.startLoading()
        APIClient.default.signInRequest(login: self.login, password: self.password, deviceID: deviceID) { [weak self] (result) in
            self?.view?.stopLoading()
            switch result {
            case let .success(response):
                AppStorage.User.Profile = response?.profile
                AppStorage.Auth.accessToken = response?.assessToken
                AppStorage.Auth.refreshToken = response?.refreshToken
                self?.view?.goToMainTabbar()
            case let .failure(error):
                self?.view?.errorAlert(message: error.localizedDescription.description)
            }
        }

    }

    func forgotPassword(with telephone: String?) {
        self.login = telephone ?? ""

        if let validationErrorDescription = validateFields() {
            view?.infoAlert(title: nil, message: validationErrorDescription)
            return
        }

        APIClient.default.forgotPasswordRequest(telephone: login) { (result) in
            switch result {
            case .success:
                self.view?.infoAlert(title: nil, message: "ForgotPassword.successMessage".localized)
            case let .failure(error):
                self.view?.errorAlert(message: error.localizedDescription)
            }
        }
    }


}

// MARK: - Privates

private extension SignInPresenter {

    /**
     Validate inputed fields
     - returns: First error of validation or nil (in second case validation successed).
    */
    func validateFields() -> String? {

        if let error = ValidationManager.validate(telephone: login) {
            return error
        }

        return nil
    }


}
