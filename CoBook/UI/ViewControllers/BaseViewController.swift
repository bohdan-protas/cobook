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
    var prototypeHud: JGProgressHUD {
        let hud = JGProgressHUD(style: .extraLight)
        hud.vibrancyEnabled = false
        hud.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        hud.animation = JGProgressHUDFadeZoomAnimation.init()
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
        hud.delegate = self
        return hud
    }

    var currentView: UIView {
        let view: UIView
        if let viewForHud = UIApplication.shared.keyWindow {
            view = viewForHud
        } else if let viewForHud = navigationController?.view {
            view = viewForHud
        } else {
            view = self.view
        }
        return view
    }

    var currentHud: JGProgressHUD?
    var onFinishDownloadCompletion: (() -> Void)?

    // MARK: LoadDisplayableView
    func startLoading() {
        currentHud = prototypeHud
        currentHud?.show(in: currentView)
    }

    func startLoading(text: String?) {
        currentHud = prototypeHud
        currentHud?.textLabel.attributedText = NSAttributedString(string: text ?? "", attributes: [.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle])
        currentHud?.show(in: currentView)
    }

    func stopLoading() {
        currentHud?.dismiss(animated: true)
    }

    func stopLoading(success: Bool) {
        self.stopLoading(success: success, completion: nil)
    }

    func stopLoading(success: Bool, completion: (() -> Void)?) {
        onFinishDownloadCompletion = completion
        UIView.animate(withDuration: 0.3) {
            self.currentHud?.indicatorView = success ? JGProgressHUDSuccessIndicatorView.init() : JGProgressHUDErrorIndicatorView.init()

            let succesText = NSAttributedString(string: "Успішно!", attributes: [.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle])
            let failureText = NSAttributedString(string: "Помилка", attributes: [.font: UIFont.SFProDisplay_Medium(size: 15), .foregroundColor: UIColor.Theme.blackMiddle])
            self.currentHud?.textLabel.attributedText = success ? succesText : failureText

            DispatchQueue.main.async {
                self.currentHud?.dismiss(afterDelay: 2, animated: true)
            }
        }
    }


}

// MARK: - NavigableView
extension BaseViewController: NavigableView {

    func push(controller: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(controller, animated: animated)
    }

    func present(controller: UIViewController, animated: Bool) {
        self.present(controller, animated: animated, completion: nil)
    }

    func popController() {
        self.navigationController?.popViewController(animated: true)
    }


}

// MARK: - JGProgressHUDDelegate
extension BaseViewController: JGProgressHUDDelegate {

    func progressHUD(_ progressHUD: JGProgressHUD, didDismissFrom view: UIView) {
        onFinishDownloadCompletion?()
        onFinishDownloadCompletion = nil
    }

}
