//
//  UIColor + Extensions.swift
//  CoBook
//
//  Created by protas on 2/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

// Convenience initialezers
extension UIColor {

    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }


}

// MARK: - Theme
extension UIColor {

    enum Theme {
        static let accent = UIColor(named: "Theme_Accent")
        static let grayBG = UIColor(named: "Theme_Gray-Background")
        static let grayUI = UIColor(named: "Theme_Gray-UI")
        static let blackMiddle = UIColor(named: "Theme_Black-Middle")
        static let greenDark = UIColor(named: "Theme_Green-Dark")
        static let green = UIColor(named: "Theme_Green")
        static let border = UIColor(named: "Theme_Border")
    }


}

extension UIColor {

    var filledImage: UIImage? {
        get {
            let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()

            context?.setFillColor(self.cgColor)
            context?.fill(rect)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return image
        }
    }

}
