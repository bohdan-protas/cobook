//
//  SignInViewController.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, SignInView {

    enum Defaults {
        static let bottomContainerHeight: CGFloat = 80
    }

    // MARK: IBOutlets
    @IBOutlet var loginTextField: CustomTextField!
    @IBOutlet var passwordTextField: CustomTextField!
    @IBOutlet var signInButton: LoaderButton!

    @IBOutlet var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet var fieldToTitleConstraint: NSLayoutConstraint!

    // MARK: Properties
    var presenter: SignInPresenter = SignInPresenter()

    private lazy var forgotPasswordAlert: UIAlertController = {
        let alertController = UIAlertController(title: "Forgot password?",
                                                message: "Enter ypor telephone number to reset",
                                                preferredStyle: .alert)

        alertController.addTextField { (textField: UITextField) -> Void in
            textField.keyboardType = .phonePad
            textField.placeholder = "Login"
        }

        let saveAction = UIAlertAction(title: "YES", style: .default, handler: { alert -> Void in
            let telephone = alertController.textFields?.first?.text
            print(telephone ?? "empty")
        })
        let cancelAction = UIAlertAction(title: "NO", style: .default, handler: nil)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        return alertController
    }()

    @IBAction func textFieldDidChanged(_ sender: Any) {
        signInButton.isEnabled = !(loginTextField.text ?? "").isEmpty && !(passwordTextField.text ?? "").isEmpty
    }

    // MARK: Actions
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        removeKeyboardObserver()
        self.present(forgotPasswordAlert, animated: true, completion: {
            self.addKeyboardObserver()
        })
    }

    @IBAction func signInButtonTapped(_ sender: LoaderButton) {

    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        if presentingViewController is SignUpNavigationController {
            performSegue(withIdentifier: SignUpNavigationController.unwindSegueId, sender: self)
        } else {
            let navigationController: SignUpNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
            navigationController.modalTransitionStyle = .crossDissolve
            navigationController.modalPresentationStyle = .overFullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    deinit {
        presenter.detachView()
    }


}

// MARK: - Private
private extension SignInViewController {

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
extension SignInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            passwordTextField.becomeFirstResponder()
        default:
            dismissKeyboard()
        }

        return true
    }


}
