//
//  CustomProgressView.swift
//  CoBook
//
//  Created by protas on 2/12/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class DesignableProgressView: UIProgressView {

    override func layoutSubviews() {
        super.layoutSubviews()

        // Set the rounded edge for the outer bar
        self.layer.cornerRadius = self.frame.height * 0.5
        self.clipsToBounds = true

        self.layer.sublayers?[0].backgroundColor = UIColor.white.cgColor

        // Set the rounded edge for the inner bar
        self.layer.sublayers?[1].cornerRadius = self.frame.height * 0.5
        self.subviews[1].clipsToBounds = true
    }

}

