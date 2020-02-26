//
//  CreatePasswordPresenter.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: - View protocol
protocol CreatePasswordView: LoadDisplayableView, AlertDisplayableView {
    func setContinueButton(enabled: Bool)
}

// MARK: - ConfirmTelephoneNumberPresenter
class CreatePasswordPresenter: BasePresenter {
    
    // MARK: Properties
    private weak var view: CreatePasswordView?
    private var password: String = ""
    private var telephone: String = AppStorage.profile.telephone.number ?? "Undefined"

    var currentTelephoneNumberToShow: String {
        return telephone
    }

    // MARK: Public
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

        APIClient.default.signUpFinishRequest(accessToken: AppStorage.accessToken ?? "", password: self.password) { (result) in
            switch result {
            case let .success(response):
                switch response.status {
                case .ok:
                    self.view?.infoAlert(title: nil, message: "Success created")

                    AppStorage.isUserCompletedRegistration = true
                    AppStorage.isUserInitiatedRegistration = false
                    AppStorage.profile = response.data?.profile
                    AppStorage.accessToken = response.data?.assessToken
                    AppStorage.refreshToken = response.data?.refreshToken

                    // TODO: go to main screen

                case .error:
                    self.view?.infoAlert(title: nil, message: response.errorLocalizadMessage)
                    debugPrint(response.errorDescription ?? "")
                }
            case let .failure(error):
                self.view?.defaultErrorAlert()
                debugPrint(error.localizedDescription)
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
