//
//  SignInViewController.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

fileprivate enum Defaults {
    static let bottomContainerHeight: CGFloat = 80
}

class SignInViewController: BaseViewController, SignInView {

    @Localized("SignIn.header")
    @IBOutlet var signInLabel: UILabel!

    @Localized("TextInput.placeholder.telephone")
    @IBOutlet var loginTextField: DesignableTextField!

    @Localized("TextInput.placeholder.password")
    @IBOutlet var passwordTextField: DesignableTextField!

    @Localized("SignIn.forgotPassword.normalTitle")
    @IBOutlet var forgotPasswordButton: UIButton!

    @Localized("Button.continue.normalTitle")
    @IBOutlet var signInButton: LoaderDesignableButton!

    @Localized("SignIn.firstTimeInCobook")
    @IBOutlet var bottomDescrLabel: UILabel!

    @Localized("SignIn.register.normalTitle")
    @IBOutlet var signUpButton: UIButton!

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

        alertController.addAction(cancelAction)
        alertController.addAction(okAction)

        return alertController
    }()

    // MARK: - Actions

    @IBAction func textFieldDidChanged(_ sender: Any) {
        presenter.set(login: loginTextField.text, password: passwordTextField.text)
    }

    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }

    @IBAction func signInButtonTapped(_ sender: LoaderDesignableButton) {
        presenter.signIn()
    }

    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        goToSignUp()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        loginTextField.text = AppStorage.User.Profile?.telephone.number
    }

    deinit {
        presenter.detachView()
    }

    // MARK: - Public

    override func startLoading() {
        signInButton.isLoading = true
    }

    override func stopLoading() {
        signInButton.isLoading = false
    }

    func setSignInButton(enabled: Bool) {
        signInButton.isEnabled = enabled
    }

    // MARK: - Navigation

    func goToSignUp() {
        if presentingViewController is SignUpNavigationController {
            performSegue(withIdentifier: SignUpNavigationController.unwindSegueId, sender: self)
        } else {
            let navigationController: SignUpNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
            navigationController.modalTransitionStyle = .coverVertical
            navigationController.modalPresentationStyle = .overFullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }

    func goToMainTabbar() {
        let mainTabbar = MainTabBarController()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = mainTabbar
        }
    }


}

// MARK: - UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField:
            passwordTextField.becomeFirstResponder()
        default:
            view.endEditing(true)
        }

        return true
    }


}
