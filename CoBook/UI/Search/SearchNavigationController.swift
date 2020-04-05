//
//  SearchNavigationController.swift
//  CoBook
//
//  Created by protas on 4/5/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class SearchNavigationController: CustomNavigationController {

    weak var searchTableViewControllerDelegate: SearchTableViewControllerDelegate?

    override func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        super.navigationController(navigationController, willShow: viewController, animated: animated)
        if viewController is SearchTableViewController {
            (viewController as! SearchTableViewController).delegate = searchTableViewControllerDelegate
        }
    }

}
