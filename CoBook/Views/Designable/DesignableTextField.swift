//
//  CustomTextField.swift
//  CoBook
//
//  Created by protas on 2/17/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableTextField: UITextField {

    // MARK: Properties
    @IBInspectable
    public var bottomTextInset: CGFloat = 0 {
        didSet { textPadding.bottom = bottomTextInset }
    }

    @IBInspectable
    public var leftTextInset: CGFloat = 0 {
        didSet { textPadding.left = leftTextInset }
    }

    @IBInspectable
    public var rightTextInset: CGFloat = 0 {
        didSet { textPadding.right = rightTextInset }
    }

    @IBInspectable
    public var topTextInset: CGFloat = 0 {
        didSet { textPadding.top = topTextInset }
    }

    @IBInspectable
    var placeholderColor: UIColor = .black {
        didSet { setPlaceholderColor(value: placeholderColor) }
    }

    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet { setCorners(value: cornerRadius) }
    }

    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet { setBorderWidth(value: borderWidth) }
    }

    @IBInspectable
    var disabledBorderColor: UIColor = UIColor.Theme.TextField.borderInactive ?? UIColor.white {
        didSet { refreshBorderColor() }
    }

    @IBInspectable
    var enabledBorderColor: UIColor = UIColor.Theme.TextField.borderActive ?? UIColor.white {
        didSet { refreshBorderColor() }
    }

    var textPadding = UIEdgeInsets.zero

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        refreshBorderColor()
    }

    override func resignFirstResponder() -> Bool {
        let resigned = super.resignFirstResponder()
        self.layoutIfNeeded()
        return resigned
    }

    // MARK: Setup
    func sharedInit() {
        self.clipsToBounds = true
        self.borderStyle = .none
        setPlaceholderColor(value: placeholderColor)
        setCorners(value: cornerRadius)
        setBorderWidth(value: borderWidth)
        refreshBorderColor()
    }

    // MARK: Text rect padding
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    // MARK: Helpers
    private func setPlaceholderColor(value: UIColor) {
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: value])
    }

    private func setBorderWidth(value: CGFloat) {
        layer.borderWidth = value
    }

    private func refreshBorderColor() {
        layer.borderColor = isEditing ? enabledBorderColor.cgColor : disabledBorderColor.cgColor
    }

    private func setCorners(value: CGFloat) {
        layer.cornerRadius = value
    }

}
