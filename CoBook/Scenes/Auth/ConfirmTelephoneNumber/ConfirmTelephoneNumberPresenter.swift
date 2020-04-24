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
    func setFormatedTimer(label: String)
    func setTimerLabel(isHidden: Bool)
    func setResendButton(isLoading: Bool)
}

// MARK: - ConfirmTelephoneNumberPresenter

class ConfirmTelephoneNumberPresenter: BasePresenter {

    private weak var view: ConfirmTelephoneNumberView?
    private var smsResendLeftInSec: TimeInterval = 0
    private var resendSmsTimer: Timer?

    // MARK: Lifecycle

    func attachView(_ view: ConfirmTelephoneNumberView) {
        self.view = view
    }

    func detachView() {
        self.view = nil
        resendSmsTimer?.invalidate()
        resendSmsTimer = nil
    }

    deinit {
        resendSmsTimer?.invalidate()
        resendSmsTimer = nil
    }

    // MARK: - Public

    func verify(with smsCode: String) {
        view?.startLoading()
        APIClient.default.verifyRequest(smsCode: Int(smsCode) ?? 0, accessToken: AppStorage.Auth.accessToken ?? "") { (result) in
            self.view?.stopLoading()

            switch result {
            case .success:
                self.view?.goToCreatePasswordController()
            case let .failure(error):
                self.view?.errorAlert(message: error.localizedDescription)
            }

        }
    }

    func resendSms() {
        view?.setResendButton(isLoading: true)
        APIClient.default.resendSmsRequest(accessToken: AppStorage.Auth.accessToken ?? "") { (result) in
            self.view?.setResendButton(isLoading: false)
            switch result {
            case let .success(response):
                AppStorage.Auth.accessToken = response?.accessToken
                let leftInMs = response?.smsResendLeftInMs ?? 0
                self.smsResendLeftInSec = leftInMs * 0.001
                self.runTimer()
            case let .failure(error):
                self.view?.errorAlert(message: error.localizedDescription.description)
            }
        }

    }


}

// MARK: - Privates

private extension ConfirmTelephoneNumberPresenter {

    func runTimer() {
        if resendSmsTimer.isNil && smsResendLeftInSec > 0 {
            view?.setTimerLabel(isHidden: false)
            resendSmsTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                  target: self,
                                                  selector: #selector(updateTimer),
                                                  userInfo: nil,
                                                  repeats: true)
            resendSmsTimer?.tolerance = 0.1
        }
    }

    @objc func updateTimer() {
        self.smsResendLeftInSec -= 1

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]

        self.view?.setFormatedTimer(label: formatter.string(from: smsResendLeftInSec) ?? "00:00")
        if self.smsResendLeftInSec == 0 {
            self.view?.setTimerLabel(isHidden: true)
            resendSmsTimer?.invalidate()
            resendSmsTimer = nil
        }
    }


}
