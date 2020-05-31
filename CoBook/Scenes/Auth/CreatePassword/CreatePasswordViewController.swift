//
//  CreatePasswordViewController.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CreatePasswordViewController: BaseViewController, CreatePasswordView {

    @Localized("CreatePassword.header")
    @IBOutlet var headerLabel: UILabel!

    @Localized("CreatePassword.description")
    @IBOutlet var descriptionLabel: UILabel!

    @Localized("TextInput.placeholder.telephone")
    @IBOutlet var telephoneNumberTextField: DesignableTextField!

    @Localized("TextInput.placeholder.password")
    @IBOutlet var passwordTextField: DesignableTextField!

    @Localized("Button.continue.normalTitle")
    @IBOutlet var continueButton: LoaderDesignableButton!

    var presenter: CreatePasswordPresenter = CreatePasswordPresenter()

    // MARK: - Actions

    @IBAction func passwordTextFieldDidChangeValue(_ sender: UITextField) {
        presenter.set(password: sender.text)
    }

    @IBAction func continueButtonTapped(_ sender: Any) {
        presenter.finishRegistration()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.attachView(self)
        telephoneNumberTextField.placeholder = presenter.currentTelephoneNumberToShow
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.becomeFirstResponder()
    }

    // MARK: - Public

    func setContinueButton(enabled: Bool) {
        continueButton.isEnabled = enabled
    }

    override func startLoading() {
        continueButton.isLoading = true
    }

    override func stopLoading() {
        continueButton.isLoading = false
    }

    func goTo(viewController: UIViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
    }


}

// MARK: - UITextFieldDelegate

extension CreatePasswordViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }


}
