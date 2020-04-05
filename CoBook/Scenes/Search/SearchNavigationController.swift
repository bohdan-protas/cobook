//
//  SearchNavigationController.swift
//  CoBook
//
//  Created by protas on 4/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SearchNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.titleTextAttributes = [.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle]

        /// disable bottom separator
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = UIColor.Theme.grayBG
        navigationBar.tintColor = UIColor.Theme.blackMiddle
        navigationBar.isTranslucent = true
    }

}
