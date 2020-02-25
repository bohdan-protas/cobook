//
//  BaseView.swift
//  CoBook
//
//  Created by protas on 2/21/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

public protocol BaseView: class {
    func startLoading()
    func stopLoading()
}

extension BaseView {
    func startLoading() { }
    func stopLoading() { }
}

protocol AlertDisplayableView {
    func defaultErrorAlert()
    func infoAlert(title: String?, message: String?)
}

extension AlertDisplayableView where Self: UIViewController {

    func infoAlert(title: String? = "", message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func defaultErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "Some error occured. Try again later.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
