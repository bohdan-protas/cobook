//
//  SignUpViewController.swift
//  CoBook
//
//  Created by protas on 2/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, SignUpViewProtocol {

    enum Defaults {
        static let bottomContainerHeight: CGFloat = 80
    }

    // MARK: IBOutlets
    @IBOutlet var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet var fieldToTitleConstraint: NSLayoutConstraint!
    @IBOutlet var userNameTextField: CustomTextField!
    @IBOutlet var telephoneNumberTextField: CustomTextField!
    @IBOutlet var emailTextField: CustomTextField!
    @IBOutlet var continueButton: LoaderButton!

    // MARK: Properties
    var presenter: SignUpPresenterProtocol = SignUpPresenter()

    // MARK: Actions
    @IBAction func signUpButtonTapped(_ sender: LoaderButton) {

    }

    @IBAction func textFieldEditingChanged(_ sender: CustomTextField) {
        continueButton.isEnabled = presenter.checkFields(name: userNameTextField.text,
                                                         telephone: telephoneNumberTextField.text,
                                                         email: emailTextField.text)
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
        NotificationCenter.default.addObserver(self, selector: #selector(obKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: Observers
    @objc private func obKeyboardWillShow(notification: NSNotification) {
        let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt

        bottomContainerConstraint.constant = keyboardSize.height
        fieldToTitleConstraint.isActive = true

        UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc private func onKeyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt

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
        case userNameTextField:
            telephoneNumberTextField.becomeFirstResponder()
        case telephoneNumberTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            view.endEditing(true)
        default:
            view.endEditing(true)
        }

        return true
    }
}
