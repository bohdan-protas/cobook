//
//  UIView + Extensions.swift
//  CoBook
//
//  Created by protas on 2/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

extension UIView {

    static var identifier: String {
        return String(describing: self.self)
    }

    static var nib: UINib {
        return UINib.init(nibName: self.identifier, bundle: Bundle.init(for: self.self))
    }

    
}
