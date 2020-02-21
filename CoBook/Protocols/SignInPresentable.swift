//
//  LoginShowableNavigation.swift
//  CoBook
//
//  Created by protas on 2/21/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

protocol SignInPresentable: class {

}

extension SignInPresentable where Self: UINavigationController {

    func presentSignIn() {
        let controller: SignInViewController = UIStoryboard.auth.initiateViewControllerFromType()
        controller.modalPresentationStyle = .overFullScreen
        self.present(controller, animated: true, completion: nil)
    }

}
