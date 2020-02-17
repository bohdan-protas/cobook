//
//  CustomButton.swift
//  CoBook
//
//  Created by protas on 2/17/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import ObjectiveC

@IBDesignable
class CustomButton: UIButton {

    // MARK: Properties
    var disabledColorHandle: UInt8 = 0
    var highlightedColorHandle: UInt8 = 0
    var selectedColorHandle: UInt8 = 0

    @IBInspectable
    var disabledBgColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &disabledColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .disabled)
                objc_setAssociatedObject(self, &disabledColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @IBInspectable
    var highlightedBgColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &highlightedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .highlighted)
            } else {
                self.setBackgroundImage(nil, for: .highlighted)
                objc_setAssociatedObject(self, &highlightedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @IBInspectable
    var normalBgColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &selectedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .normal)
                objc_setAssociatedObject(self, &selectedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .normal)
                objc_setAssociatedObject(self, &selectedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @IBInspectable
    var selectedBgColor: UIColor? {
        get {
            if let color = objc_getAssociatedObject(self, &selectedColorHandle) as? UIColor {
                return color
            }
            return nil
        }
        set {
            if let color = newValue {
                self.setBackgroundColor(color, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                self.setBackgroundImage(nil, for: .selected)
                objc_setAssociatedObject(self, &selectedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setCorners(value: cornerRadius)
        }
    }

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
        sharedInit()
    }

    // MARK: Setup
    func sharedInit() {
        self.clipsToBounds = true

        setCorners(value: cornerRadius)

    }

    // MARK: Helpers
    private func setCorners(value: CGFloat) {
        layer.cornerRadius = value
    }

    private func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(color.filledImage, for: state)
    }

    

}
