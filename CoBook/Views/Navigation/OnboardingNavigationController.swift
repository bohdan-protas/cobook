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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
