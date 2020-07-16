//
//  CreatePasswordPresenter.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

// MARK: - View protocol
protocol CreatePasswordView: class, LoadDisplayableView, AlertDisplayableView {
    func setContinueButton(enabled: Bool)
    func goToMainTabbar()
}

// MARK: - ConfirmTelephoneNumberPresenter
class CreatePasswordPresenter: BasePresenter {

    private weak var view: CreatePasswordView?
    private var password: String = ""
    private var telephone: String = AppStorage.User.Profile?.telephone.number ?? "Undefined"

    var currentTelephoneNumberToShow: String {
        return telephone
    }

    // MARK: - Public

    func attachView(_ view: CreatePasswordView) {
        self.view = view
    }

    func detachView() {
        self.view = nil
    }

    func set(password: String?) {
        self.password = password ?? ""
        view?.setContinueButton(enabled: !self.password.isEmpty)
    }

    func finishRegistration() {
        if let validationErrorDescription = validateFields() {
            view?.infoAlert(title: nil, message: validationErrorDescription)
            return
        }

        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        if deviceID == nil {
            Log.error("device ID is not defined!")
        }
        
        APIClient.default.signUpFinishRequest(accessToken: AppStorage.Auth.accessToken ?? "", password: self.password, deviceID: deviceID) { (result) in
            switch result {
            case let .success(response):
                AppStorage.Auth.accessToken = response?.assessToken
                AppStorage.Auth.refreshToken = response?.refreshToken

                AppStorage.User.isUserCompletedRegistration = true
                AppStorage.User.isUserInitiatedRegistration = false
                AppStorage.User.Profile = response?.profile

                self.view?.goToMainTabbar()
            case let .failure(error):
                self.view?.errorAlert(message: error.localizedDescription.description, handler: nil)
            }
        }
    }


}

// MARK: - Privates

private extension CreatePasswordPresenter {

    func validateFields() -> String? {
        if let error = ValidationManager.validate(password: password) {
            return error
        }

        if let error = ValidationManager.validate(telephone: telephone) {
            return error
        }

        return nil
    }
    

}
