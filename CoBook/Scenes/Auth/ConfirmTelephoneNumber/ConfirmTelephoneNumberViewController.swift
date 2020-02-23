//
//  ConfirmTelephoneNumberViewController.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class ConfirmTelephoneNumberViewController: UIViewController {

    enum Defaults {
        static let bottomContainerHeight: CGFloat = 80
    }

    // MARK: IBOutlets
    @IBOutlet var smsCodeTextFields: [UITextField]!
    @IBOutlet var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet var continueButton: LoaderButton!

    //MARK: Actions
    @IBAction func smsTextFieldDidChanged(_ sender: UITextField) {
        guard let index: Int = smsCodeTextFields.firstIndex(of: sender) else {
            return
        }

        if (sender.text ?? "").isEmpty {
            smsCodeTextFields[safe: index-1]?.becomeFirstResponder()
        } else {
            smsCodeTextFields[safe: index+1]?.becomeFirstResponder()
        }

        /// if each text field is no empty
        let arrayOfTruth = smsCodeTextFields.map { !($0.text ?? "").isEmpty }
        continueButton.isEnabled = !arrayOfTruth.contains(false)
    }

    @IBAction func continueButtonTapped(_ sender: LoaderButton) {
        self.performSegue(withIdentifier: CreatePasswordViewController.segueId, sender: nil)
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    deinit {
        removeKeyboardObserver()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}

// MARK: - Privates
private extension ConfirmTelephoneNumberViewController {

    func setupLayout() {
        addKeyboardObserver()
        smsCodeTextFields[safe: 0]?.becomeFirstResponder()
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
extension ConfirmTelephoneNumberViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        } else {
            return textField.text?.isEmpty ?? false
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }


}
