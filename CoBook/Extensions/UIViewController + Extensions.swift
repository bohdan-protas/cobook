//
//  UIViewController + Extensions.swift
//  CoBook
//
//  Created by protas on 2/10/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

extension UIViewController {

    static var describing: String {
        return String.init(describing: self.self)
    }

    static var segueId: String {
        return "goTo\(String(describing: self.self))"
    }

    static var unwindSegueId: String {
        return "unwindTo\(String(describing: self.self))"
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

extension UIViewController {




}
