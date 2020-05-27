//
//  BottomLoaderView.swift
//  CoBook
//
//  Created by protas on 5/27/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class BottomLoaderView: BaseFromNibView {

    @IBOutlet var loader: UIActivityIndicatorView!

    override func getNib() -> UINib {
        return BottomLoaderView.nib
    }

}
