//
//  OnboardingNavigationController.swift
//  CoBook
//
//  Created by protas on 2/21/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class OnboardingNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Вітаємо в спільноті CoBook"
        self.navigationItem.setHidesBackButton(true, animated: false)
    }


}

