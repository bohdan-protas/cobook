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

    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars = ["F","F"] + chars
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
    }


}

// MARK: - Theme
extension UIColor {

    enum Theme {
        static let accent = UIColor(named: "Theme_Accent")!
        static let grayBG = UIColor(named: "Theme_Gray-Background")!
        static let grayUI = UIColor(named: "Theme_Gray-UI")!
        static let blackMiddle = UIColor(named: "Theme_Black-Middle")!
        static let greenDark = UIColor(named: "Theme_Green-Dark")!
        static let green = UIColor(named: "Theme_Green")!
        static let border = UIColor(named: "Theme_Border")!


        enum TextField {
            static let borderActive = UIColor.init(named: "Theme_TextField-borderActive")
            static let borderInactive = UIColor.init(named: "Theme_TextField-borderInactive")
        }

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
