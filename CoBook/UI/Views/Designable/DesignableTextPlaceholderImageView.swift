//
//  TextPlaceholderDesignableImageView.swift
//  CoBook
//
//  Created by protas on 3/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableTextPlaceholderImageView: UIImageView {

    /// Title text to render inside the image
    @IBInspectable var placeholder: String? {
        didSet {
            configure()
        }
    }

    override var image: UIImage? {
        didSet {
            configure()
        }
    }

    /// The color of the title text
    @IBInspectable var placeholderColor: UIColor = .black

    /// The font size of the title text
    @IBInspectable var fontSize: CGFloat = 20

    /// The label used to render title and size text
    private var placeholderLabel: UILabel!

    /// Adjustment in font size to make the title font slightly bigger
    private let titleFontSizeAdjustment: CGFloat = 0

    override required init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
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

    /**
     This configures the size label according to the current
     settings. This will get called whenever the image view
     is re-laid out (e.g. after rotation).
    */
    private func configure() {
        clipsToBounds = true

        if placeholderLabel == nil {
            // make sure we don't render the label outside of ourselves
            placeholderLabel = UILabel(frame: bounds)
            placeholderLabel.numberOfLines = 0
            placeholderLabel.textAlignment = .center
            addSubview(placeholderLabel)

            // center the label inside the placeholder space
            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
            placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            placeholderLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
            placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }

        placeholderLabel.isHidden = image != nil

        let titleAttrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize + titleFontSizeAdjustment)]
        let titleString = NSMutableAttributedString(string: placeholder ?? "", attributes: titleAttrs)

        // append the size string and put it inside the label
        placeholderLabel.attributedText = titleString

        // make sure the label color reflects the latest setting
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.backgroundColor = .clear
    }


}
