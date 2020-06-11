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

    @Localized("SignUp.registration")
    @IBOutlet var headerLabel: UILabel!

    @Localized("TextInput.placeholder.firstName")
    @IBOutlet var firstNameTextField: DesignableTextField!

    @Localized("TextInput.placeholder.lastName")
    @IBOutlet var lastNameTextField: DesignableTextField!

    @Localized("TextInput.placeholder.telephone")
    @IBOutlet var telephoneNumberTextField: DesignableTextField!

    @Localized("TextInput.placeholder.email")
    @IBOutlet var emailTextField: DesignableTextField!

    @Localized("Button.continue.normalTitle")
    @IBOutlet var continueButton: LoaderDesignableButton!

    @Localized("SignUp.alreadyHaveAccountQuestion")
    @IBOutlet var enterQuestionLabel: UILabel!

    @Localized("SignUp.enterButton.normalTitle")
    @IBOutlet var enterButton: UIButton!

    @IBOutlet var termsAndConditionsLabel: UILabel!

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

    @objc func handleTermTapped(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: termsAndConditionsLabel)
        let index = termsAndConditionsLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)

        let termString = "SignUp.termsAndConditions.text".localized as NSString
        let termRange = termString.range(of: "SignUp.termsAndConditions.linkText".localized)

        if checkRange(termRange, contain: index) {
            UIApplication.shared.open(Constants.CoBook.termsAndConditionsURL)
        }

    }

    // MARK: - Lifecycle

	override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)

        let formattedText = String.format(strings: ["SignUp.termsAndConditions.linkText".localized],
                                          boldFont: UIFont.HelveticaNeueCyr_Bold(size: 13),
                                          boldColor: UIColor.Theme.green,
                                          inString: "SignUp.termsAndConditions.text".localized,
                                          font: UIFont.HelveticaNeueCyr_Medium(size: 13),
                                          color: UIColor.Theme.green)
        termsAndConditionsLabel.attributedText = formattedText
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
        termsAndConditionsLabel.addGestureRecognizer(tap)
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

    // MARK: - Helpers

    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
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

extension UILabel {

    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }


}

extension String {

    static func format(strings: [String],
                       boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                       boldColor: UIColor = UIColor.blue,
                       inString string: String,
                       font: UIFont = UIFont.systemFont(ofSize: 14),
                       color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: string,
                                      attributes: [
                                        .font: font,
                                        .foregroundColor: color])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }


}
