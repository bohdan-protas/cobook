//
//  AddFeedbackViewController.swift
//  CoBook
//
//  Created by Bogdan Protas on 18.06.2020.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AddFeedbackViewController: BaseViewController {

    @Localized("Feedback.title")
    @IBOutlet var titleLabel: UILabel!
    
    @Localized("Feedback.placeholder.message")
    @IBOutlet var messageTextView: DesignableTextView!
    
    @Localized("Feedback.placeholder.leaveComment.normalTitle")
    @IBOutlet var addButton: LoaderDesignableButton!
    
    @IBOutlet var bottomConstaint: NSLayoutConstraint!
    
    var presenter: AddFeedbackPresenter?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        presenter?.view = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandler), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandler), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageTextView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Actions
    
    @objc func keyboardWillShowHandler(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomConstaint.constant = keyboardHeight
            
            UIView.animate(withDuration: 0.1) {
                self.messageTextView.layoutIfNeeded()
                self.messageTextView.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHideHandler(_ notification: Notification) {
        bottomConstaint.constant = 16
        UIView.animate(withDuration: 0.1) {
            self.messageTextView.layoutIfNeeded()
            self.messageTextView.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.presenter?.createFeedback()
    }
        

}

// MARK: - AddFeedbackViewController

extension AddFeedbackViewController: AddFeedbackView {
    
    func setButton(actived: Bool) {
        addButton.isEnabled = actived
    }
    
    
}

// MARK: - Privates

extension AddFeedbackViewController {
    
    func setupLayout() {
        self.navigationItem.title = "Feedback.title".localized
        self.messageTextView.delegate = self
    }
    
    
}

// MARK: - UITextViewDelegate
 
extension AddFeedbackViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        presenter?.set(message: textView.text)
    }
  
    
}
