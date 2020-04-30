//
//  UIStoryboard + ControllerInitiate.swift
//  CoBook
//
//  Created by protas on 4/30/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

extension UIStoryboard {

    func initiateViewControllerFromType<T: UIViewController>() -> T {
        guard let vc = self.instantiateViewController(withIdentifier: T.describing) as? T else {
            fatalError("Some error with initiating view controller with specified type")
        }
        return vc
    }


}
