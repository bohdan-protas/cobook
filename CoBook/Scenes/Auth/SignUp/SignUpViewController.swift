//
//  SignUpViewController.swift
//  CoBook
//
//  Created by protas on 2/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

fileprivate enum Defaults {
    static let bottomContainerHeight: CGFloat = 80
}

class SignUpViewController: BaseViewController, SignUpView {

    @IBOutlet var firstNameTextField: DesignableTextField!
    @IBOutlet var lastNameTextField: DesignableTextField!
    @IBOutlet var telephoneNumberTextField: DesignableTextField!
    @IBOutlet var emailTextField: DesignableTextField!
    @IBOutlet var continueButton: LoaderDesignableButton!

    var presenter = SignUpPresenter()

    // MARK: -  Actions
    @IBAction func signUpButtonTapped(_ sender: LoaderDesignableButton) {
        presenter.signUp()
    }

    @IBAction func textFieldEditingChanged(_ sender: DesignableTextField) {
        presenter.set(firstName: firstNameTextField.text,
                      lastName: lastNameTextField.text,
                      telephone: telephoneNumberTextField.text,
                      email: emailTextField.text)
    }

    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
    }

    // MARK: - Lifecycle

	override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
    }

    deinit {
        presenter.detachView()
    }

    // MARK: -  SignUpView

    override func startLoading() {
        continueButton.isLoading = true
    }

    override func stopLoading() {
        continueButton.isLoading = false
    }

    func setContinueButton(actived: Bool) {
        continueButton.isEnabled = actived
    }

    // MARK: - Navigation

    func goToConfirmTelephoneNumber() {
        self.performSegue(withIdentifier: ConfirmTelephoneNumberViewController.segueId, sender: nil)
    }


}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            telephoneNumberTextField.becomeFirstResponder()
        case telephoneNumberTextField:
            emailTextField.becomeFirstResponder()
        default:
            view.endEditing(true)
        }

        return true
    }


}
