//
//  CreatePasswordPresenter.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

// MARK: - View protocol
protocol CreatePasswordView: LoadDisplayableView, AlertDisplayableView {
    func setContinueButton(enabled: Bool)
    func goTo(viewController: UIViewController)
}

// MARK: - ConfirmTelephoneNumberPresenter
class CreatePasswordPresenter: BasePresenter {
    
    // MARK: Properties
    private weak var view: CreatePasswordView?
    private var password: String = ""
    private var telephone: String = AppStorage.profile?.telephone.number ?? "Undefined"

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
                    AppStorage.isUserCompletedRegistration = true
                    AppStorage.isUserInitiatedRegistration = false

                    AppStorage.profile = response.data?.profile
                    AppStorage.accessToken = response.data?.assessToken
                    AppStorage.refreshToken = response.data?.refreshToken

                    self.view?.goTo(viewController: MainTabBarController())

                case .error:
                    debugPrint("Error:  [\(response.errorId ?? "-1")], \(response.errorDescription ?? "")")
                    self.view?.errorAlert(message: response.errorLocalizadMessage, handler: nil)
                }
            case let .failure(error):
                debugPrint("Error: [\(error.responseCode ?? 0)], \(error.errorDescription ?? "")")
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
