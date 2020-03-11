//
//  DesignableTextView.swift
//  CoBook
//
//  Created by protas on 3/11/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

// MARK: - DesignableTextView
@IBDesignable
class DesignableTextView: UITextView {

    // MARK: Title text
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var disabledBorderColor: UIColor = UIColor.Theme.TextField.borderInactive ?? UIColor.clear
    @IBInspectable var enabledBorderColor: UIColor = UIColor.Theme.TextField.borderActive ?? UIColor.clear

    @IBInspectable var isEnabled: Bool = false {
        didSet { layer.borderColor = isEnabled ? enabledBorderColor.cgColor : disabledBorderColor.cgColor }
    }

    // MARK: Title text
    @IBInspectable public var bottomTextInset: CGFloat = 0 {
        didSet { textPadding.bottom = bottomTextInset }
    }

    @IBInspectable public var leftTextInset: CGFloat = 0 {
        didSet { textPadding.left = leftTextInset }
    }

    @IBInspectable public var rightTextInset: CGFloat = 0 {
        didSet { textPadding.right = rightTextInset }
    }

    @IBInspectable public var topTextInset: CGFloat = 0 {
        didSet { textPadding.top = topTextInset }
    }
    private var textPadding = UIEdgeInsets.zero

    // MARK: Placeholder
    private var placeholderLabel: UILabel!
    private var placeholderLabelTopConstraint: NSLayoutConstraint?
    private var placeholderLabelLeftConstraint: NSLayoutConstraint?
    private var placeholderLabelRightConstraint: NSLayoutConstraint?
    private var placeholderLabelBottomConstraint: NSLayoutConstraint?

    @IBInspectable var pFontSize: CGFloat = 14
    @IBInspectable var pText: String = ""
    @IBInspectable var pTextColor: UIColor = .black
    @IBInspectable var pBgColor: UIColor = .clear

    @IBInspectable public var pBottomTextInset: CGFloat = 16
    @IBInspectable public var pLeftTextInset: CGFloat = 16
    @IBInspectable public var pRightTextInset: CGFloat = 16
    @IBInspectable public var pTopTextInset: CGFloat = 16

    // MARK: - Initializers
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    // MARK: Layout
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        configure()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }

    override func resignFirstResponder() -> Bool {
        let resigned = super.resignFirstResponder()
        self.layoutIfNeeded()
        return resigned
    }


}

// MARK: - Privates
private extension DesignableTextView {

    func configure() {
        clipsToBounds = true

        layer.borderWidth = borderWidth
        layer.borderColor = isEnabled ? enabledBorderColor.cgColor : disabledBorderColor.cgColor
        layer.cornerRadius = cornerRadius
        textContainerInset = textPadding
        textContainer.lineFragmentPadding = 0

        if placeholderLabel == nil {

            // Make sure we don't render the label outside of ourselves
            placeholderLabel = UILabel()
            placeholderLabel.numberOfLines = 0
            placeholderLabel.textAlignment = .left
            addSubview(placeholderLabel)

            // Setup the label inside the placeholder space
            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

            // Setup the placeholder position
            placeholderLabelLeftConstraint = placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: pLeftTextInset)
            placeholderLabelRightConstraint = placeholderLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: pRightTextInset)
            placeholderLabelTopConstraint = placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: pTopTextInset)
            placeholderLabelBottomConstraint = placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: pBottomTextInset)

            // Activate the placeholder position
            placeholderLabelLeftConstraint?.isActive = true
            placeholderLabelRightConstraint?.isActive = true
            placeholderLabelTopConstraint?.isActive = true
            placeholderLabelBottomConstraint?.isActive = true
        }

        // Update the placeholder position
        placeholderLabelLeftConstraint?.constant = pLeftTextInset
        placeholderLabelRightConstraint?.constant = pRightTextInset
        placeholderLabelTopConstraint?.constant = pTopTextInset
        placeholderLabelBottomConstraint?.constant = pBottomTextInset

        let pAttrs = [NSAttributedString.Key.font: UIFont.SFProDisplay_Regular(size: pFontSize)]
        let pString = NSMutableAttributedString(string: pText, attributes: pAttrs)

        placeholderLabel.attributedText = pString
        placeholderLabel.textColor = pTextColor
        placeholderLabel.backgroundColor = pBgColor

        placeholderLabel.layoutIfNeeded()
        placeholderLabel.sizeToFit()
    }


}

// MARK: - UITextViewDelegate
extension DesignableTextView: UITextViewDelegate {

    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    public func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.count > 0
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        isEnabled = true
    }


    func textViewDidEndEditing(_ textView: UITextView) {
        isEnabled = false
    }


}
