//
//  BaseViewController.swift
//  CoBook
//
//  Created by protas on 3/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import JGProgressHUD

class BaseViewController: UIViewController, LoadDisplayableView {
    let hud = JGProgressHUD(style: .extraLight)

    func startLoading() {
        DispatchQueue.main.async {
            self.showSimpleHUD()
        }

    }

    func stopLoading() {
        DispatchQueue.main.async {
            self.hud.dismiss()
        }
    }

    func showSimpleHUD() {
        hud.vibrancyEnabled = true
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
        hud.show(in: self.view)
    }


}
