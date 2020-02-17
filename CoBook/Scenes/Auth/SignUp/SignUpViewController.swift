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
    @IBOutlet var imageContainer: UIView!
    @IBOutlet var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet var titleImageView: UIImageView!

    // MARK: Properties
    var presenter: SignUpPresenterProtocol = SignUpPresenter()

    @IBAction func signUpButtonTapped(_ sender: LoaderButton) {
        sender.isLoading.toggle()
    }

    // MARK: Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }


}

// MARK: - Private
private extension SignUpViewController {

    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChangeFrame), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Observer
    @objc private func keyboardChangeFrame(notification: NSNotification) {
        guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let isKeyboardBecomeHide = notification.name == UIResponder.keyboardWillHideNotification
        bottomContainerConstraint.constant = isKeyboardBecomeHide ? Defaults.bottomContainerHeight : keyboardSize.height
        UIView.animate(withDuration: 0.1) {
            self.imageContainer.isHidden = !isKeyboardBecomeHide
            self.view.layoutIfNeeded()
        }
    }


}
