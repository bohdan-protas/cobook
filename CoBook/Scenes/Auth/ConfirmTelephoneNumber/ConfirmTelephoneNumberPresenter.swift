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
    private weak var view: ConfirmTelephoneNumberView?

    // MARK: Public
    func attachView(_ view: ConfirmTelephoneNumberView) {
        self.view = view
    }

    func detachView() {
        self.view = nil
    }

    func verify(with smsCode: String) {
        view?.startLoading()

        APIClient.default.verifyRequest(smsCode: Int(smsCode) ?? 0, accessToken: AppStorage.accessToken ?? "") { (result) in
            self.view?.stopLoading()

            switch result {
            case let .success(response):
                if response.status == .ok, response.data?.isSuccess == true {
                    self.view?.goToCreatePasswordController()
                } else {
                    self.view?.infoAlert(title: nil, message: response.errorLocalizadMessage)
                }
            case let .failure(error):
                self.view?.defaultErrorAlert()
                debugPrint(error.localizedDescription)
            }

        }
    }


}
