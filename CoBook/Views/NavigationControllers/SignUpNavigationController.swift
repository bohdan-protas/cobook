//
//  SignInNavigationController.swift
//  CoBook
//
//  Created by protas on 2/21/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SignUpNavigationController: CustomNavigationController {

    
    override func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.title = "Вітаємо в спільноті CoBook"
        viewController.navigationItem.setHidesBackButton(true, animated: false)
        super.navigationController(navigationController, willShow: viewController, animated: animated)
    }

}
