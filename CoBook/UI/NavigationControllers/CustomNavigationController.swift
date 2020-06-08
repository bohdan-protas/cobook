//
//  CustomNavigationController.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import PanModal

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
        self.delegate = self
    }


}

// MARK: - PanModalPresentable

extension CustomNavigationController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return (topViewController as? PanModalPresentable)?.panScrollable
    }

    var longFormHeight: PanModalHeight {
        return .maxHeight
    }

    var shortFormHeight: PanModalHeight {
        return longFormHeight
    }

}

// MARK: - UINavigationControllerDelegate

extension CustomNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
        proxyDelegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }

}
