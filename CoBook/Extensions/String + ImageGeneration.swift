//
//  String + ImageGeneration.swift
//  CoBook
//
//  Created by protas on 4/16/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

extension String {

    /// Generates a `UIImage` instance from this string using a specified
    /// attributes and size.
    ///
    /// - Parameters:
    ///     - size: of the image to return.
    ///     - fontSize: to draw this string with. Default is `nil`.
    /// - Returns: a `UIImage` instance from this string using a specified
    /// attributes and size, or `nil` if the operation fails.
    func image(size: CGSize, fontSize: CGFloat? = nil) -> UIImage? {

        let fontSize: CGFloat = fontSize ?? size.width * 0.4

        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        style.lineBreakMode = .byClipping

        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.Theme.blackMiddle,
                                                         .font: UIFont.boldSystemFont(ofSize: fontSize),
                                                         .paragraphStyle: style]

        let richText = NSMutableAttributedString(string: self, attributes: attributes)

        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.attributedText = richText
        label.numberOfLines = 0

        return UIGraphicsImageRenderer(size: size).image { _ in
            label.drawText(in: CGRect(origin: .zero, size: size))
        }
    }

}
