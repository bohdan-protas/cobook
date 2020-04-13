//
//  CorneredEdgeView.swift
//  CoBook
//
//  Created by protas on 4/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CorneredEdgeView: BaseFromNibView {

    @IBOutlet var corneredView: UIView!

    override func setupLayout() {
        corneredView.clipsToBounds = true
        corneredView.layer.cornerRadius = 8
        corneredView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    override func getNib() -> UINib {
        return CorneredEdgeView.nib
    }


}
