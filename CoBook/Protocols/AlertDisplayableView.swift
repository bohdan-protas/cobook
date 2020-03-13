//
//  AlertDisplayableView.swift
//  CoBook
//
//  Created by protas on 2/26/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol AlertDisplayableView {
    func defaultErrorAlert()
    func infoAlert(title: String?, message: String?)
    func errorAlert(message: String?)
    func errorAlert(message: String?, handler: ((UIAlertAction) -> Void)?) 
}

extension AlertDisplayableView where Self: UIViewController {

    func infoAlert(title: String? = "", message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func errorAlert(message: String?, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: "Error".localized, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK".localized, style: .default, handler: handler)
        alertController.addAction(OKAction)

        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.present(alertController, animated: true, completion: nil)
        }
    }

    func errorAlert(message: String?) {
        errorAlert(message: message, handler: nil)
    }

    func defaultErrorAlert() {
        let alertController = UIAlertController(title: "Error".localized, message: "Some error occured. Try again later.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }


}
