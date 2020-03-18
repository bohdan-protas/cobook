//
//  BaseViewController.swift
//  CoBook
//
//  Created by protas on 3/13/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import JGProgressHUD
import Alamofire

class BaseViewController: UIViewController, LoadDisplayableView, AlertDisplayableView {

    // MARK: Properties
    lazy var hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .extraLight)
        hud.vibrancyEnabled = true
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
        return hud
    }()

    // MARK: LoadDisplayableView
    func startLoading() {
        let view: UIView
        if let viewForHud = UIApplication.shared.keyWindow {
            view = viewForHud
        } else if let viewForHud = navigationController?.view {
            view = viewForHud
        } else {
            view = self.view
        }
        self.hud.show(in: view)
    }

    func stopLoading() {
        self.hud.dismiss(animated: true)
    }


}
