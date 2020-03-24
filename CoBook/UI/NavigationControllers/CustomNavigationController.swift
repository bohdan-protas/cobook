//
//  CustomNavigationController.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    private weak var proxyDelegate: UINavigationControllerDelegate?

    override var delegate: UINavigationControllerDelegate? {
        willSet {
            if newValue !== self {
                proxyDelegate = newValue
                self.delegate = self
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /// back button image and color
        navigationBar.backIndicatorImage = #imageLiteral(resourceName: "ic_arrow_back")
        navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "ic_arrow_back")
        navigationBar.tintColor = UIColor.Theme.blackMiddle

        /// setup navigation title
        navigationBar.titleTextAttributes = [.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle]

        /// make navigation bg transparent
        navigationBar.setBackgroundImage(UIColor.Theme.grayBG.filledImage, for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .white

        self.delegate = self
    }


}

// MARK: - UINavigationControllerDelegate
extension CustomNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
        proxyDelegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        proxyDelegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }

}
