//
//  CreatePasswordViewController.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CreatePasswordViewController: UIViewController, CreatePasswordView {

    enum Defaults {
        static let bottomContainerHeight: CGFloat = 80
    }

    // MARK: IBOutlets
    @IBOutlet var telephoneNumberTextField: DesignableTextField!
    @IBOutlet var passwordTextField: DesignableTextField!
    @IBOutlet var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet var continueButton: LoaderButton!

    var presenter: CreatePasswordPresenter = CreatePasswordPresenter()

    // MARK: Actions
    @IBAction func passwordTextFieldDidChangeValue(_ sender: UITextField) {
        presenter.set(password: sender.text)
    }

    @IBAction func continueButtonTapped(_ sender: Any) {
        presenter.finishRegistration()
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.attachView(self)
        setupLayout()
    }

    // MARK: Public
    func setContinueButton(enabled: Bool) {
        continueButton.isEnabled = enabled
    }

    func startLoading() {
        continueButton.isLoading = true
    }

    func stopLoading() {
        continueButton.isLoading = false
    }


}

// MARK: - Privates
private extension CreatePasswordViewController {

    func setupLayout() {
        telephoneNumberTextField.placeholder = presenter.currentTelephoneNumberToShow
        addKeyboardObserver()
        passwordTextField.becomeFirstResponder()
    }

    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: Observers
    @objc private func onKeyboardWillShow(notification: NSNotification) {
        let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        bottomContainerConstraint.constant = keyboardSize.height
    }

    @objc private func onKeyboardWillHide(notification: NSNotification) {
        bottomContainerConstraint.constant = Defaults.bottomContainerHeight
    }


}

// MARK: - UITextFieldDelegate
extension CreatePasswordViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }


}
