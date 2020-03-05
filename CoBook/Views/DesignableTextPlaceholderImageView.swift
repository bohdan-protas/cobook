//
//  TextPlaceholderDesignableImageView.swift
//  CoBook
//
//  Created by protas on 3/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

@IBDesignable class DesignableTextPlaceholderImageView: DesignableImageView {

    /// Title text to render inside the image
    @IBInspectable var textPlaceholder: String = ""

    /// The color of the title text
    @IBInspectable var textColor: UIColor = .black

    /// The backgroun color of the title text
    @IBInspectable var textBgColor: UIColor = .white

    /// The font size of the title text
    @IBInspectable var textFontSize: CGFloat = 20

    /// The label used to render title and size text
    private var label: UILabel!

    /// Adjustment in font size to make the title font slightly bigger
    private let titleFontSizeAdjustment: CGFloat = 4

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

        guard image == nil else {
            label = nil
            return
        }

        if label == nil {
            // make sure we don't render the label outside of ourselves
            label = UILabel(frame: bounds)
            label.numberOfLines = 0
            label.textAlignment = .center
            addSubview(label)

            // center the label inside the placeholder space
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            label.topAnchor.constraint(equalTo: topAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        }

        let titleAttrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: textFontSize + titleFontSizeAdjustment)]
        let titleString = NSMutableAttributedString(string: textPlaceholder, attributes: titleAttrs)

        // append the size string and put it inside the label
        label.attributedText = titleString

        // make sure the label color reflects the latest setting
        label.textColor = textColor
        label.backgroundColor = textBgColor

        layer.cornerRadius = cornerRadius
    }


}
