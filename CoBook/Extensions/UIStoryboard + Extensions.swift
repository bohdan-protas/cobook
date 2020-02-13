//
//  UIStoryboard + Extensions.swift
//  CoBook
//
//  Created by protas on 2/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

private enum StoryboardNames {
    static let auth: String = "Auth"

}

extension UIStoryboard {

    func initiateViewControllerFromType<T: UIViewController>() -> T {
        guard let vc = self.instantiateViewController(withIdentifier: T.describing) as? T else {
            fatalError("Some error with initiating view controller with specified type")
        }
        return vc
    }
}
