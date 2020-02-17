//
//  SignUpViewController.swift
//  CoBook
//
//  Created by protas on 2/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, SignUpViewProtocol {

    @IBOutlet var imageContainer: UIView!
    @IBOutlet var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet var titleImageView: UIImageView!
    var presenter: SignUpPresenterProtocol = SignUpPresenter()

	override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        hideKeyboardWhenTappedAround()
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomContainerConstraint.constant = keyboardSize.height
            UIView.animate(withDuration: 0.1) {
                self.imageContainer.isHidden = true
                self.view.layoutIfNeeded()
            }
        }

    }

    @objc func keyboardWillHide(notification: Notification) {
        bottomContainerConstraint.constant = 80
        UIView.animate(withDuration: 0.1) {
            self.imageContainer.isHidden = true
            self.view.layoutIfNeeded()
        }
    }

}
