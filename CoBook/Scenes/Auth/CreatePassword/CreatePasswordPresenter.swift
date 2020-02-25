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
    private var telephone: String = UserDataManager.default.telephone ?? ""

    var currentTelephoneNumberToShow: String {
        return UserDataManager.default.telephone ?? "Undefined"
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

        APIClient.default.signUpFinishRequest(accessToken: UserDataManager.default.accessToken ?? "", password: self.password) { (result) in
            switch result {
            case let .success(response):
                switch response.status {
                case .ok:
                    self.view?.infoAlert(title: nil, message: "Success created")

                    UserDataManager.default.password = self.password
                    UserDataManager.default.accessToken = response.data?.assessToken
                    UserDataManager.default.refreshToken = response.data?.refreshToken

                    // TODO: go to main screen

                case .error:
                    self.view?.infoAlert(title: nil, message: response.errorLocalizadMessage)
                    UserDataManager.default.accessToken = nil
                    debugPrint(response.errorDescription ?? "")
                }
            case let .failure(error):
                self.view?.defaultErrorAlert()
                UserDataManager.default.accessToken = nil
                debugPrint(error.localizedDescription)
            }
        }
    }


}

// MARK: - Privates
private extension CreatePasswordPresenter {

    // TODO: move this code to separated validaiton manager
    func validateFields() -> String? {
        if password.count > 25 || password.count < 6 {
            return "Error.Validation.password".localized
        }

        if !RegularExpression.init(pattern: .telephone).match(in: telephone) {
             return "Error.Validation.telephone".localized
        }

        return nil
    }

}
