//
//  TransparentNavigationBar.swift
//  CoBook
//
//  Created by protas on 2/21/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class TransparentNavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    override func prepareForInterfaceBuilder() {
        sharedInit()
    }

    // MARK: Setup
    func sharedInit() {
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        self.barTintColor = .white
        self.titleTextAttributes = [.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle]
    }


}
