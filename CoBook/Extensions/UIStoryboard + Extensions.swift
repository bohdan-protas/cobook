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
    static let account: String = "Account"
}

extension UIStoryboard {

    static var auth: UIStoryboard {
        return UIStoryboard(name: StoryboardNames.auth, bundle: nil)
    }

    static var account: UIStoryboard {
        return UIStoryboard(name: StoryboardNames.account, bundle: nil)
    }

    static var search: UIStoryboard {
        return UIStoryboard(name: "Search", bundle: nil)
    }

    func initiateViewControllerFromType<T: UIViewController>() -> T {
        guard let vc = self.instantiateViewController(withIdentifier: T.describing) as? T else {
            fatalError("Some error with initiating view controller with specified type")
        }
        return vc
    }
}
