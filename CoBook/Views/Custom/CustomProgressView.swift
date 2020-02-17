//
//  CustomProgressView.swift
//  CoBook
//
//  Created by protas on 2/12/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CustomProgressView: UIProgressView {

    override func layoutSubviews() {
        super.layoutSubviews()

        // Set the rounded edge for the outer bar
        self.layer.cornerRadius = self.cornerRadius
        self.clipsToBounds = true

        // Set the rounded edge for the inner bar
        self.layer.sublayers?[1].cornerRadius = self.cornerRadius
        self.subviews[1].clipsToBounds = true
    }

}

