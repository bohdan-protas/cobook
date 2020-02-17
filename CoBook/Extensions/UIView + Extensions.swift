//
//  UIView + Extensions.swift
//  CoBook
//
//  Created by protas on 2/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

// MARK: -
extension UIView {

    static var identifier: String {
        return String(describing: self.self)
    }

    static var nib: UINib {
        return UINib.init(nibName: self.identifier, bundle: Bundle.init(for: self.self))
    }

    
}

//MARK: - Shadow
extension UIView {

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }


}

//MARK: - Border
extension UIView {




}
