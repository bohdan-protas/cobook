//
//  BaseViewController.swift
//  CoBook
//
//  Created by protas on 3/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController, LoadDisplayableView {

    lazy var progressHUD: MBProgressHUD? = {
        let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        return progressHUD
    }()

    func startLoading() {
        progressHUD?.show(animated: true)
    }

    func stopLoading() {
        progressHUD?.hide(animated: true)
    }


}
