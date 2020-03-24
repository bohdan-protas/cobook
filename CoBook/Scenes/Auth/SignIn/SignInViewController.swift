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
    @IBOutlet var loginTextField: DesignableTextField!
    @IBOutlet var passwordTextField: DesignableTextField!
    @IBOutlet var signInButton: LoaderButton!
    @IBOutlet var navBar: TransparentNavigationBar!

    @IBOutlet var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet var fieldToTitleConstraint: NSLayoutConstraint!

    // MARK: Properties
    var presenter: SignInPresenter = SignInPresenter()

    private lazy var forgotPasswordAlert: UIAlertController = {
        let alertController = UIAlertController(title: "ForgotPassword.title".localized,
                                                message: "ForgotPassword.subtitle".localized,
                                                preferredStyle: .alert)

        alertController.addTextField { (textField: UITextField) -> Void in
            textField.keyboardType = .phonePad
            textField.placeholder = "Login.placeholder".localized
        }

        let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: { alert -> Void in
            let telephone = alertController.textFields?.first?.text
            self.presenter.forgotPassword(with: telephone)
        })
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .destructive, handler: nil)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        return alertController
    }()

    // MARK: Actions
    @IBAction func textFieldDidChanged(_ sender: Any) {
        presenter.set(login: loginTextField.text, password: passwordTextField.text)
    }

    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        removeKeyboardObserver()
        self.present(forgotPasswordAlert, animated: true, completion: {
            self.addKeyboardObservers()
        })
    }

    @IBAction func signInButtonTapped(_ sender: LoaderButton) {
        presenter.signIn()
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        goToSignUp()
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         setupLayout()
     }

    deinit {
        presenter.detachView()
    }

    // MARK: Public
    func startLoading() {
        signInButton.isLoading = true
    }

    func stopLoading() {
        signInButton.isLoading = false
    }

    func setSignInButton(enabled: Bool) {
        signInButton.isEnabled = enabled
    }

    // MARK: Navigation
    func goToSignUp() {
        if presentingViewController is SignUpNavigationController {
            performSegue(withIdentifier: SignUpNavigationController.unwindSegueId, sender: self)
        } else {
            let navigationController: SignUpNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
            navigationController.modalTransitionStyle = .crossDissolve
            navigationController.modalPresentationStyle = .overFullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }

    func goTo(viewController: UIViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
    }


}

// MARK: - Private
private extension SignInViewController {

    func setupLayout() {
        navBar.topItem?.title = "SignIn.title".localized

        // In small screen devices disable title image
        if UIDevice().isSmallScreenType {
            fieldToTitleConstraint.isActive = true
            view.layoutIfNeeded()
        } else {
            addKeyboardObservers()
        }
    }

    private func addKeyboardObservers() {
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
