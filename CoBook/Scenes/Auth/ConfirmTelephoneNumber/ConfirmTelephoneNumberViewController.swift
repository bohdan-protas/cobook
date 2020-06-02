//
//  ConfirmTelephoneNumberViewController.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

fileprivate enum Defaults {
    static let bottomContainerHeight: CGFloat = 80
}

class ConfirmTelephoneNumberViewController: BaseViewController, ConfirmTelephoneNumberView {

    @IBOutlet var smsCodeTextFields: [UITextField]!
    @IBOutlet var timerLabel: UILabel!

    @Localized("ConfirmTelephone.header")
    @IBOutlet var headerLabel: UILabel!

    @Localized("ConfirmTelephone.description")
    @IBOutlet var descroptionLabel: UILabel!

    @Localized("Button.continue.normalTitle")
    @IBOutlet var continueButton: LoaderDesignableButton!

    @Localized("ConfirmTelephone.smsNotArrivedQuestion.normalTitle")
    @IBOutlet var resendSmsButton: LoaderDesignableButton!

    var presenter: ConfirmTelephoneNumberPresenter? = ConfirmTelephoneNumberPresenter()

    //MARK: - Actions

    @IBAction func smsTextFieldDidChanged(_ sender: UITextField) {
        guard let index: Int = smsCodeTextFields.firstIndex(of: sender) else {
            return
        }

        if (sender.text ?? "").isEmpty {
            smsCodeTextFields[safe: index-1]?.becomeFirstResponder()
        } else {
            smsCodeTextFields[safe: index+1]?.becomeFirstResponder()
        }

        /// if each text field is no empty
        let arrayOfTruth = smsCodeTextFields.map { !($0.text ?? "").isEmpty }
        continueButton.isEnabled = !arrayOfTruth.contains(false)
    }

    @IBAction func continueButtonTapped(_ sender: LoaderDesignableButton) {
        let code = smsCodeTextFields.map { $0.text ?? "" }.reduce("", { $0 + $1 })
        presenter?.verify(with: code)
    }
    
    @IBAction func resendSmsButtonTapped(_ sender: Any) {
        presenter?.resendSms()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachView(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        smsCodeTextFields[safe: 0]?.becomeFirstResponder()
    }

    deinit {
        presenter?.detachView()
    }

    // MARK - Public

    func setFormatedTimer(label: String) {
        self.timerLabel.text = label
    }

    func setTimerLabel(isHidden: Bool) {
        timerLabel.isHidden = isHidden
        resendSmsButton.isHidden = !isHidden
    }

    func setResendButton(isLoading: Bool) {
        resendSmsButton.isLoading = isLoading
    }

    override func startLoading() {
        continueButton.isLoading = true
    }

    override func stopLoading() {
        continueButton.isLoading = false
    }

    func goToCreatePasswordController() {
        self.performSegue(withIdentifier: CreatePasswordViewController.segueId, sender: nil)
    }


}

// MARK: - UITextFieldDelegate

extension ConfirmTelephoneNumberViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        } else {
            return textField.text?.isEmpty ?? false
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }


}
