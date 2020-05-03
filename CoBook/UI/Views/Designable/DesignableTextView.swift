//
//  DesignableTextView.swift
//  CoBook
//
//  Created by protas on 3/11/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

// MARK: - DesignableTextView
/** @abstract UITextView with placeholder support   */
@IBDesignable class DesignableTextView: IQTextView {

    // MARK: - State colors

    @IBInspectable var disabledBorderColor: UIColor = UIColor.Theme.TextField.borderInactive ?? UIColor.clear
    @IBInspectable var enabledBorderColor: UIColor = UIColor.Theme.TextField.borderActive ?? UIColor.clear

    @IBInspectable var isEnabled: Bool = false {
        didSet { configureLayout() }
    }

    // MARK: - Title text insets

    @IBInspectable
    public var bottomTextInset: CGFloat = 0 {
        didSet { textContainerInset.bottom = bottomTextInset }
    }

    @IBInspectable
    public var leftTextInset: CGFloat = 0 {
        didSet { textContainerInset.left = leftTextInset }
    }

    @IBInspectable
    public var rightTextInset: CGFloat = 0 {
        didSet { textContainerInset.right = rightTextInset }
    }

    @IBInspectable
    public var topTextInset: CGFloat = 0 {
        didSet { textContainerInset.top = topTextInset }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: - Rendering

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayout()
    }

    override func resignFirstResponder() -> Bool {
        let resigned = super.resignFirstResponder()
        self.layoutIfNeeded()
        return resigned
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Public

    @objc internal func setActivedState() {
        isEnabled = true
    }

    @objc internal func seDefaultState() {
        isEnabled = false
    }


}

// MARK: - Privates

private extension DesignableTextView {

    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.setActivedState), name: UITextView.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.seDefaultState), name: UITextView.textDidEndEditingNotification, object: self)
    }

    func configureLayout() {
        clipsToBounds = true
        textContainer.lineFragmentPadding = 0
        layer.borderColor = isEnabled ? enabledBorderColor.cgColor : disabledBorderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius


    }


}

// MARK: - UITextViewDelegate

//extension DesignableTextView: UITextViewDelegate {
//
//    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
//    func textViewDidChange(_ textView: UITextView) {
//        refreshPlaceholder()
//        proxyDelegate?.textViewDidChange?(self)
//    }
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        isEnabled = true
//        proxyDelegate?.textViewDidBeginEditing?(self)
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        isEnabled = false
//        proxyDelegate?.textViewDidEndEditing?(self)
//    }
//
//
//}
