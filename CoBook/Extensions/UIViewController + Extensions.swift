//
//  UIViewController + Extensions.swift
//  CoBook
//
//  Created by protas on 2/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

extension UIViewController {

    static var describing: String {
        return String.init(describing: self.self)
    }

}
