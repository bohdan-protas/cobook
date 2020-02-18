//
//  ShadowView.swift
//  CoBook
//
//  Created by protas on 2/18/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowView: UIView {

    @IBInspectable var shadowOffset: CGSize = CGSize.zero
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var shadowRadius: CGFloat = 0
    @IBInspectable var shadowOpacity: Float = 0

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.masksToBounds = false
        layer.shadowOffset = shadowOffset
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.cornerRadius = shadowRadius

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }

}
