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

    var hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .extraLight)
        hud.vibrancyEnabled = true
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
        return hud
    }()

    func startLoading() {
        DispatchQueue.main.async {
            self.hud.show(in: self.view)
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            self.hud.dismiss()
        }
    }


}
