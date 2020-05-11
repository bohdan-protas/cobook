//
//  MainTabBarController.swift
//  CoBook
//
//  Created by protas on 3/4/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let accountController: AccountNavigationController = UIStoryboard.account.initiateViewControllerFromType()
        accountController.tabBarItem = UITabBarItem(title: "Account".localized, image: #imageLiteral(resourceName: "ic_tabbar_account_inactive"), selectedImage: #imageLiteral(resourceName: "ic_tabbar_account_active"))

        let allCardsController: CardsOverviewNavigationController = UIStoryboard.allCards.initiateViewControllerFromType()
        allCardsController.tabBarItem = UITabBarItem(title: "AllCards".localized, image: #imageLiteral(resourceName: "ic_tabbar_allcards_inactive"), selectedImage: #imageLiteral(resourceName: "ic_tabbar_allcards_active"))

        self.viewControllers = [allCardsController, accountController]
        self.selectedViewController = accountController
    }
    

}
