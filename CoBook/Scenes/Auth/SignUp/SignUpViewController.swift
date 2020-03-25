//
//  SignUpViewController.swift
//  CoBook
//
//  Created by protas on 2/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController, SignUpView {

    enum Defaults {
        static let bottomContainerHeight: CGFloat = 80
    }

    // MARK: IBOutlets
    @IBOutlet var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet var fieldToTitleConstraint: NSLayoutConstraint!
    @IBOutlet var firstNameTextField: DesignableTextField!
    @IBOutlet var lastNameTextField: DesignableTextField!
    @IBOutlet var telephoneNumberTextField: DesignableTextField!
    @IBOutlet var emailTextField: DesignableTextField!
    @IBOutlet var continueButton: LoaderDesignableButton!

    // MARK: Properties
    var presenter = SignUpPresenter()

    // MARK: Actions
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

    // MARK: Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }

    deinit {
        presenter.detachView()
    }

    // MARK: SignUpView
    override func startLoading() {
        continueButton.isLoading = true
    }

    override func stopLoading() {
        continueButton.isLoading = false
    }

    func setContinueButton(actived: Bool) {
        continueButton.isEnabled = actived
    }

    // MARK: Navigation
    func goToConfirmTelephoneNumber() {
        self.performSegue(withIdentifier: ConfirmTelephoneNumberViewController.segueId, sender: nil)
    }


}

// MARK: - Private
private extension SignUpViewController {

    func setupLayout() {
        /// In small screen devices disable title image
        if UIDevice().isSmallScreenType {
            fieldToTitleConstraint.isActive = true
            view.layoutIfNeeded()
        } else {
            addKeyboardObserver()
        }
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
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt

        bottomContainerConstraint.constant = keyboardSize.height
        fieldToTitleConstraint.isActive = true

        UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc private func onKeyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt

        bottomContainerConstraint.constant = Defaults.bottomContainerHeight
        fieldToTitleConstraint.isActive = false

        UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
