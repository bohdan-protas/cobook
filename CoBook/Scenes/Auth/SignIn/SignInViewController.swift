//
//  SignInViewController.swift
//  CoBook
//
//  Created by protas on 2/19/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBAction func signUpButtonTapped(_ sender: Any) {
        if presentingViewController is SignUpNavigationController {
            performSegue(withIdentifier: SignUpNavigationController.unwindSegueId, sender: self)
        } else {
            let navigationController: SignUpNavigationController = UIStoryboard.auth.initiateViewControllerFromType()
            navigationController.modalTransitionStyle = .crossDissolve
            navigationController.modalPresentationStyle = .overFullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
