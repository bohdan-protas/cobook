//
//  AccountNavigationController.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class AccountNavigationController: CustomNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        super.navigationController(navigationController, willShow: viewController, animated: animated)

        viewController.navigationController?.setNavigationBarHidden(viewController is AccountViewController || viewController is PartnershipInfoViewController, animated: true)
    }
    

}
