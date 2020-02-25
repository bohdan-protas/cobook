//
//  ConfirmTelephoneNumberPresenter.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import Foundation

// MARK: - View protocol
protocol ConfirmTelephoneNumberView: LoadDisplayableView, AlertDisplayableView {
    func goToCreatePasswordController()
}

// MARK: - ConfirmTelephoneNumberPresenter
class ConfirmTelephoneNumberPresenter: BasePresenter {
    weak var view: ConfirmTelephoneNumberView?

    // MARK: Public
    func attachView(_ view: ConfirmTelephoneNumberView) {
        self.view = view
    }

    func detachView() {
        self.view = nil
    }

    func verify(with smsCode: String) {
        view?.startLoading()

        APIClient.default.verifyRequest(smsCode: Int(smsCode) ?? 0, accessToken: UserDataManager.default.accessToken ?? "") { (result) in
            self.view?.stopLoading()

            switch result {
            case let .success(response):
                if response.status == .ok, response.data?.isSuccess == true {
                    self.view?.goToCreatePasswordController()
                } else {
                    self.view?.infoAlert(title: nil, message: response.errorLocalizadMessage)
                    UserDataManager.default.accessToken = nil
                }
            case let .failure(error):
                UserDataManager.default.accessToken = nil
                self.view?.defaultErrorAlert()
                debugPrint(error.localizedDescription)
            }
        }
    }


}
