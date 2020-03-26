//
//  CustomButton.swift
//  CoBook
//
//  Created by protas on 2/17/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

@IBDesignable
open class DesignableButton: UIButton {

    @IBInspectable public var defaultColor: UIColor? {
        didSet {
            self.configureLayout()
        }
    }

    @IBInspectable public var selectedColor: UIColor? {
        didSet {
            self.configureLayout()
        }
    }

    @IBInspectable public var disabledColor: UIColor? {
        didSet {
            self.configureLayout()
        }
    }

    // support for Dynamic Type without allowing the text to grow too big to fit
    @IBInspectable public var adjustsFontSizeToFitWidth: Bool = false {
        didSet {
            self.titleLabel?.adjustsFontForContentSizeCategory = self.adjustsFontSizeToFitWidth
            self.titleLabel?.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth
            self.titleLabel?.baselineAdjustment = self.adjustsFontSizeToFitWidth ? .alignCenters : .alignBaselines

            if self.adjustsFontSizeToFitWidth {
                // When dynamic text changes we need to redraw the layout
                NotificationCenter.default.addObserver(forName: UIContentSizeCategory.didChangeNotification, object: nil, queue: OperationQueue.main) { [weak self] notification in
                    guard let strongSelf = self else { return }
                    strongSelf.setNeedsLayout()
                }
            }
            else {
                NotificationCenter.default.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
            }
        }
    }

    open override var isHighlighted: Bool {
        didSet {
            self.configureLayout()
        }
    }

    open override var isSelected: Bool {
        didSet {
            self.configureLayout()
        }
    }

    open override var isEnabled: Bool {
        didSet {
            self.configureLayout()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        self.configureLayout()
    }

    public func configureLayout() {
        if isHighlighted || isSelected {
            self.backgroundColor = selectedColor
        } else if isEnabled {
            self.backgroundColor = defaultColor
        }
        else {
            self.backgroundColor = disabledColor
        }

        self.reversesTitleShadowWhenHighlighted = false
        self.showsTouchWhenHighlighted = false
        self.adjustsImageWhenHighlighted = false

        self.titleLabel?.textAlignment = .center
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = .byClipping //<-- MAGIC LINE

        assert(self.buttonType == UIButton.ButtonType.custom, "Designable Button \"\(self.titleLabel?.text ?? "?")\" buttonType must be Custom")
    }
}

// helper to put icon above text
public extension UIButton {

    func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding

        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )

        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
}
