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
    private var smsResendLeftInSeconds: TimeInterval = 0

    private var resendSmsTimer: Timer?

    // MARK: Public
    init(smsResendLeftInSeconds: TimeInterval) {
        self.smsResendLeftInSeconds = smsResendLeftInSeconds
    }

    func attachView(_ view: ConfirmTelephoneNumberView) {
        self.view = view
    }

    func detachView() {
        self.view = nil
        resendSmsTimer?.invalidate()
        resendSmsTimer = nil
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

    func resendSms() {
        view?.setResendButton(isLoading: true)
        APIClient.default.resendSmsRequest(accessToken: AppStorage.accessToken ?? "") { (result) in
            self.view?.setResendButton(isLoading: true)
            switch result {
            case let .success(response):
                switch response.status {
                case .ok:
                    AppStorage.accessToken = response.data?.accessToken
                    let leftInMs = response.data?.smsResendLeftInMiliseconds ?? 0
                    self.smsResendLeftInSeconds = leftInMs * 0.01
                    self.runTimer()
                case .error:
                    self.view?.infoAlert(title: nil, message: response.errorLocalizadMessage)
                }
            case let .failure(error):
                self.view?.defaultErrorAlert()
                debugPrint(error.localizedDescription)
            }
        }

    }


}

// MARK: - Privates
private extension ConfirmTelephoneNumberPresenter {

    func runTimer() {
        if resendSmsTimer.isNil && smsResendLeftInSeconds > 0 {
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
        self.smsResendLeftInSeconds -= 1
        self.view?.setFormatedTimer(label: self.smsResendLeftInSeconds.minuteSecond)
        if self.smsResendLeftInSeconds == 0 {
            self.view?.setTimerLabel(isHidden: true)
            resendSmsTimer?.invalidate()
            resendSmsTimer = nil
        }
    }


}
